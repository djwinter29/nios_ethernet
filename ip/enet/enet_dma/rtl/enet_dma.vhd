library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use ieee.std_logic_misc.all;

entity EnetDataDMA is
    port( 
        csi_clock_clk          : in  std_logic                          := '0';
        csi_clock_reset        : in  std_logic                          := '0';
        
        -- Configuration
        avs_cfg_address        : in  std_logic_vector(3 downto 0);
        avs_cfg_byteenable     : in  std_logic_vector(3 downto 0);
        avs_cfg_read           : in  std_logic; 
        avs_cfg_readdata       : out std_logic_vector(31 downto 0);
        avs_cfg_write          : in  std_logic;             
        avs_cfg_writedata      : in  std_logic_vector(31 downto 0);
        
        -- Filter Config
        aso_filter_data        : out std_logic_vector(79 downto 0);
        
        -- interupt
        ins_irq_enet           : out std_logic;
        
        -- Input data from Ethernet MAC
        asi_in_ready           : out std_logic;
        asi_in_valid           : in  std_logic                          := '0';
        asi_in_startofpacket   : in  std_logic;
        asi_in_endofpacket     : in  std_logic;
        asi_in_error           : in  std_logic_vector(5 downto 0);
        asi_in_empty           : in  std_logic_vector(1 downto 0);
        asi_in_data            : in  std_logic_vector(31 downto 0);
        
        -- Output data to Ethernet MAC
        aso_out_ready          : in  std_logic;
        aso_out_valid          : out std_logic := '0';
        aso_out_startofpacket  : out std_logic;
        aso_out_endofpacket    : out std_logic;
        aso_out_error          : out std_logic;
        aso_out_empty          : out std_logic_vector(1 downto 0);
        aso_out_data           : out std_logic_vector(31 downto 0);
        
        -- Ram block integraded in this module now
        avm_read_address       : out std_logic_vector(31 downto 0);
        avm_read_read          : out std_logic;
        avm_read_waitrequest   : in  std_logic;
        avm_read_readdata      : in  std_logic_vector(31 downto 0)      := (others => '0');
        
        avm_write_address      : out std_logic_vector(31 downto 0);
        avm_write_write        : out std_logic;
        avm_write_waitrequest  : in  std_logic;
        avm_write_writedata    : out std_logic_vector(31 downto 0)      := (others => '0')
    );
end entity EnetDataDMA;


architecture RTL of EnetDataDMA is
    signal address          : integer;
    -- Test Code
    type array_type is array (0 to 15) of std_logic_vector(31 downto 0);
    signal RegValue         : array_type     := (others => (others => '0'));
    
    
    -- Reg 0: Settings and Status
    signal  EnetPacketSize  : unsigned(31 downto 0)                     := (others => '0');
    -- Reg 1: General Settings and status
    
    -- Reg 2: Recieve Start Address
    signal  RxStartAddress  : std_logic_vector(31 downto 0)             := (others => '0');
    -- Reg 3: Recieve Information
    --signal  RxLength        : 
    
    -- Reg  8: 
    
    -- Reg  9: 
    
    -- Reg 10: Sent Length 1 & 2
    
    -- Reg 11: Sent Length 3 & 4
    
    -- Reg 12: Sent Start Address1
    
    -- Reg 13: Sent Start Address2
    
    -- Reg 14: Sent Start Address3
    
    -- Reg 15: Sent Start Address4
    
    
    
    

begin
    address <= to_integer(unsigned(avs_cfg_address));
    -- *******************Configuration Memory Slave ******************************
    -- Cfg Read
    avs_cfg_readdata            <= RegValue(address);
    -- Cfg Write
    ConfigurationProc :process
    begin
        wait until rising_edge(csi_clock_clk);
        
        if csi_clock_reset = '1'  then
            RegValue        <= (others => (others => '0'));
        elsif avs_cfg_write = '1' then
            if avs_cfg_byteenable(0) = '1' then
                RegValue(address)(7 downto 0)   <= avs_cfg_writedata(7 downto 0) ;
            end if;
        
            if avs_cfg_byteenable(1) = '1' then
                RegValue(address)(15 downto 8)    <= avs_cfg_writedata(15 downto 8);
            end if;
                RegValue(address)   <= avs_cfg_writedata;
            if avs_cfg_byteenable(2) = '1' then
                RegValue(address)(23 downto 16)    <= avs_cfg_writedata(23 downto 16);
            end if;
            
            if avs_cfg_byteenable(3) = '1' then
                RegValue(address)(31 downto 24)    <= avs_cfg_writedata(31 downto 24);
            end if;
        
            
        end if;
    end process;
    -- ****************************************************************************
    aso_filter_data         <= (others => '0');
    ins_irq_enet            <= '0';
    
    asi_in_ready           <= aso_out_ready;
    
    aso_out_valid          <= asi_in_valid;
    aso_out_startofpacket  <= asi_in_startofpacket;
    aso_out_endofpacket    <= asi_in_endofpacket;
    aso_out_error          <= or_reduce(asi_in_error);
    aso_out_empty          <= asi_in_empty;
    aso_out_data           <= asi_in_data;
    
    avm_read_address       <= (others => '0');
    avm_read_read          <= '0';
    
    avm_write_address      <= (others => '0');
    avm_write_write        <= '0';
    avm_write_writedata    <= (others => '0');
    
    
end architecture RTL;
