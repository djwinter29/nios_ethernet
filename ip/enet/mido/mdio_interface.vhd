library IEEE;
use IEEE.std_logic_1164.all;

entity mdio_interface_top is
    port(
        mdc_pad          : in  std_logic;
        mdio_in_pad      : out std_logic;
        mdio_out_pad     : in  std_logic;
        mdio_oen_pad     : in  std_logic;
        
        mdc              : out std_logic;
        mdio             : inout std_logic
    );
end entity mdio_interface_top;


architecture RTL of mdio_interface_top is
begin
    mdc                             <= mdc_pad;
    
    mdio_in_pad                     <= mdio;
    mdio                            <= mdio_out_pad when mdio_oen_pad = '0' else 'Z';
end architecture RTL;
