LIBRARY ieee, core;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
use core.core;


entity PerfDev is
    port (
        -- Clock and Reset
        Ref_clk                         : in  std_logic:= '0';
        
        -- ******* Ethernet (MAC to Marvell PHY) *********
        -- MDIO
        Enet_mdc        :   out std_logic;
        Enet_mdio       : inout std_logic;  
        
        -- RGMII 
        Enet_rx_clk     :    in std_logic                               := 'X';
        Enet_rx_en      :    in std_logic                               := 'X';
        Enet_rx_d       :    in std_logic_vector(3 downto 0)            := (others => 'X');
        Enet_gtx_clk    :   out std_logic;
        Enet_tx_en      :   out std_logic;
        Enet_tx_d       :   out std_logic_vector(3 downto 0);
        
        -- PHY Reset 
        Enet_reset_n    :   out std_logic
        -- **************** Ethernet End ******************
        
        );
end PerfDev;


architecture rtl of PerfDev is
    signal sys_clk          : std_logic;
    signal clk_125          : std_logic;
    
    -- MDIO Temp Signal
    signal mdio_in_pad      : std_logic;
    signal mdio_out_pad     : std_logic;
    signal mdio_oen_pad     : std_logic;
    
begin


    -- ****** MDIO **************
    mdio_in_pad                     <= Enet_mdio;
    Enet_mdio                       <= mdio_out_pad when mdio_oen_pad = '0' else 'Z';
    



    sys_core : core.core
    port map (
        clk_clk                     => sys_clk,                     --                   clk.clk
        reset_reset_n               => '1',                          --                 reset.reset_n

        tse_mac_misc_ff_tx_crc_fwd => '0', --                      enet_mac_misc.ff_tx_crc_fwd
        tse_mac_misc_ff_tx_septy   => open,   --                      .ff_tx_septy
        tse_mac_misc_tx_ff_uflow   => open,   --                      .tx_ff_uflow
        tse_mac_misc_ff_tx_a_full  => open,  --                      .ff_tx_a_full
        tse_mac_misc_ff_tx_a_empty => open, --                      .ff_tx_a_empty
        tse_mac_misc_rx_err_stat   => open,   --                      .rx_err_stat
        tse_mac_misc_rx_frm_type   => open,   --                      .rx_frm_type
        tse_mac_misc_ff_rx_dsav    => open,    --                      .ff_rx_dsav
        tse_mac_misc_ff_rx_a_full  => open,  --                      .ff_rx_a_full
        tse_mac_misc_ff_rx_a_empty => open, --                      .ff_rx_a_empty
        
        tse_mac_rgmii_rgmii_in     => Enet_rx_d,     --        enet_mac_rgmii.rgmii_in
        tse_mac_rgmii_rgmii_out    => Enet_tx_d,    --                      .rgmii_out
        tse_mac_rgmii_rx_control   => Enet_rx_en,   --                      .rx_control
        tse_mac_rgmii_tx_control   => Enet_tx_en,   --                      .tx_control
        
        tse_pcs_mac_rx_clock_clk   => Enet_rx_clk,   -- enet_pcs_mac_rx_clock.clk
        tse_pcs_mac_tx_clock_clk   => clk_125,   -- enet_pcs_mac_tx_clock.clk
        
        tse_mac_status_set_10      => open,      --       enet_mac_status.set_10
        tse_mac_status_set_1000    => open,    --                      .set_1000
        tse_mac_status_eth_mode    => open,    --                      .eth_mode
        tse_mac_status_ena_10      => open,      --                      .ena_10
        
        tse_mac_mdio_mdc           => Enet_mdc,           --         tse_mac_mdio.mdc
        tse_mac_mdio_mdio_in       => mdio_in_pad,       --                     .mdio_in
        tse_mac_mdio_mdio_out      => mdio_out_pad,      --                     .mdio_out
        tse_mac_mdio_mdio_oen      => mdio_oen_pad       --                     .mdio_oen


    );
    
    thePLL : entity work.clock 
    port map
    (
        --areset  => '0',
        inclk0  => Ref_clk,
        c0      => sys_clk,
        c1      => clk_125
    );

end rtl;


