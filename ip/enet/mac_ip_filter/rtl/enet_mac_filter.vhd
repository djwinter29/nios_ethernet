library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity EnetMACDataFilter is
    port( 
        csi_clock_clk             : in  std_logic := '0';
        csi_clock_reset           : in  std_logic := '0';
        
        asi_filter_data           : in std_logic_vector(79 downto 0);
        
        -- Input data from Ethernet MAC
        asi_in_ready              : out std_logic;
        asi_in_valid              : in  std_logic := '0';
        asi_in_startofpacket      : in  std_logic;
        asi_in_endofpacket        : in  std_logic;
        asi_in_error              : in  std_logic_vector(5 downto 0);
        asi_in_empty              : in  std_logic_vector(1 downto 0);
        asi_in_data               : in  std_logic_vector(31 downto 0);
        
        -- not belong to this interface
        aso_bypass_ready          : in   std_logic;
        aso_bypass_valid          : out  std_logic := '0';
        aso_bypass_startofpacket  : out  std_logic;
        aso_bypass_endofpacket    : out  std_logic;
        aso_bypass_error          : out  std_logic;
        aso_bypass_empty          : out  std_logic_vector(1 downto 0);
        aso_bypass_data           : out  std_logic_vector(31 downto 0);
        
        -- belong to this interface
        aso_out_ready             : in   std_logic;
        aso_out_valid             : out  std_logic := '0';
        aso_out_startofpacket     : out  std_logic;
        aso_out_endofpacket       : out  std_logic;
        aso_out_error             : out  std_logic_vector(5 downto 0);
        aso_out_empty             : out  std_logic_vector(1 downto 0);
        aso_out_data              : out  std_logic_vector(31 downto 0)
    );
end entity EnetMACDataFilter;


architecture RTL of EnetMACDataFilter is
    alias MacAddress           : std_logic_vector(47 downto 0) is asi_filter_data(47 downto 0);
    signal BufferedMac         : std_logic_vector(47 downto 0);
    signal ProcessState        : std_logic_vector(1 downto 0);
    
    signal SecondWord          : std_logic  := '0';
    signal PassPacket          : std_logic  := '0';
    signal BrodcastPacket      : std_logic  := '0';
begin
    asi_in_ready            <= '1'          when ProcessState = "00"
                          else '0'          when ProcessState = "01"
                          else aso_out_ready;

    aso_bypass_valid          <= '0'                                                   when ProcessState = "00"
                          else PassPacket or BrodcastPacket                            when ProcessState = "01"
                          else asi_in_valid and (PassPacket or BrodcastPacket);
    aso_bypass_startofpacket  <= '1'                                                   when ProcessState = "01" and SecondWord = '0'   else '0';
    aso_bypass_endofpacket    <= asi_in_endofpacket                                    when ProcessState = "10"                        else '0';
    aso_bypass_empty          <= asi_in_empty                                          when ProcessState = "10"                        else (others => '0');
    aso_bypass_data           <= x"0000" & BufferedMac(47 downto 32)                   when ProcessState = "01" and SecondWord = '0'
                          else BufferedMac(31 downto 0)                                when ProcessState = "01" and SecondWord = '1'
                          else asi_in_data;


    aso_out_valid           <= '0'                                                     when ProcessState = "00"
                          else (not PassPacket) or BrodcastPacket                      when ProcessState = "01"
                          else asi_in_valid and ((not PassPacket) or BrodcastPacket);
    aso_out_startofpacket   <= '1'                                                     when ProcessState = "01" and SecondWord = '0'   else '0';
    aso_out_endofpacket     <= asi_in_endofpacket                                      when ProcessState = "10"                        else '0';
    aso_out_empty           <= asi_in_empty                                            when ProcessState = "10"                        else (others => '0');
    aso_out_data            <= x"0000" & BufferedMac(47 downto 32)                     when ProcessState = "01" and SecondWord = '0'
                          else BufferedMac(31 downto 0)                                when ProcessState = "01" and SecondWord = '1'
                          else asi_in_data ;
    
    -- Ethernet Packet is more than minmum is 60 bytes
    EnetToEngineFilter : process
    begin
        wait until rising_edge(csi_clock_clk);
        
        if csi_clock_reset = '1' then
            ProcessState    <= "00";
            SecondWord      <= '0';
            PassPacket      <= '0';
            BrodcastPacket  <= '0';
        else
            if ProcessState = "00" then
                -- Buffering
                if asi_in_startofpacket = '1' and asi_in_valid = '1' then
                    BufferedMac(47 downto 32)       <= asi_in_data (15 downto 0);
                    SecondWord                      <= '1';
                    PassPacket                      <= '0';
                    BrodcastPacket                  <= '0';
                elsif asi_in_valid = '1' then
                    BufferedMac(31 downto 0)        <= asi_in_data;
                    if (BufferedMac(47 downto 32) & asi_in_data) /= MacAddress then
                        PassPacket      <= '1';
                    end if;
                    
                    if (BufferedMac(47 downto 32) & asi_in_data) = x"FFFFFFFFFFFF" then
                        BrodcastPacket  <= '1';
                    end if;
                    
                    ProcessState                <= "01";
                    SecondWord                  <= '0';
                end if;
            elsif ProcessState = "01" then
                -- Output Header
                if aso_out_ready = '1' then
                    if SecondWord = '0' then
                        SecondWord                  <= '1';
                    else
                        SecondWord                  <= '0';
                        ProcessState                <= "10";
                    end if;
                end if;
            elsif ProcessState = "10" then
                -- By pass
                if asi_in_endofpacket = '1'  and asi_in_valid = '1' and aso_out_ready = '1' then
                    ProcessState <= "00";
                    PassPacket                      <= '0';
                    BrodcastPacket                  <= '0';
                end if;
            else
                ProcessState <= "00";
                PassPacket                      <= '0';
                BrodcastPacket                  <= '0';
            end if;
        end if;
    end process; 
end architecture RTL;
