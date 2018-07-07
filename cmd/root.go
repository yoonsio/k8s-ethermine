package cmd

var rootCmd = &cobra.Command{
	Use: "ethmonitor",
	Short: "ethmonitor monitors ethminer stat",
	Long: "ethmonitor monitors ethminer stat",
}

func Execute() {
	if err := rootCmd.Execute(); err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
}

func init() {
	cobra.OnInitialize()
	viper.SetEnvPrefix("ethmonitor")
	viper.AutomaticEnv()
}
