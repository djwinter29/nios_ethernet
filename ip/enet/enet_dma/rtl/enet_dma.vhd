library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

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
    
    
    
    
    
    
end architecture RTL;
