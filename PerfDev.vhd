LIBRARY ieee, core;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
use core.core;


entity PerfDev is
    port (
        -- Clock and Reset
        Ref_clk                         : in  std_logic:= '0'   
        );
end PerfDev;


architecture rtl of PerfDev is
    signal sys_clk          : std_logic;
    
begin
    sys_core : core.core
    port map (
        clk_clk       => sys_clk,       --   clk.clk
        reset_reset_n => '1'  -- reset.reset_n
    );
    
    thePLL : entity work.clock 
    port map
    (
        --areset  => '0',
        inclk0  => Ref_clk,
        c0      => sys_clk
    );

end rtl;


