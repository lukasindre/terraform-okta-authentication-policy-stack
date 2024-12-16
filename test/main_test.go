package test

import (
	"fmt"
	"os"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
    "gopkg.in/yaml.v3"
)

type Config struct {
	Name        string `json:"name"`
	Description string `json:"description"`
	Rules       []struct {
		Name             string   `json:"name"`
		Access           string   `json:"access"`
		NetworkZones     []string `json:"network_zones"`
		GroupTargets     []string `json:"group_targets"`
		GroupExclusions  []string `json:"group_exclusions"`
		ManagedDevice    []string `json:"managed_device"`
		UnmanagedDevice  []string `json:"unmanaged_device"`
		AuthFrequency    string   `json:"auth_frequency"`
		StepUpAuth       bool     `json:"step_up_auth"`
		PhishingResistant bool    `json:"phishing_resistant"`
	} `json:"rules"`
}

func TestTerraformOktaAppSignonPolicy(t *testing.T) {
    testFile := "./test.yaml"
    fmt.Println("Test file: ", testFile)
	tfOptions := &terraform.Options{
		TerraformDir: "../",
		Vars: map[string]interface{}{
			"yaml_filepath": testFile,
		},
	}

	defer terraform.Destroy(t, tfOptions)
	terraform.InitAndApply(t, tfOptions)

	policyID := terraform.Output(t, tfOptions, "authentication_policy_id")
	assert.NotEmpty(t, policyID, "Policy ID should not be empty")

	configFile, err := os.ReadFile(testFile)
	assert.NoError(t, err, "Failed to read config file")

	var config Config
	err = yaml.Unmarshal(configFile, &config)
	assert.NoError(t, err, "Failed to parse config file")

    assert.Equal(t, len(config.Rules), 1, "Rules should not be empty")

    groups := terraform.OutputList(t, tfOptions, "groups")
    assert.Equal(t, len(groups), 2, "There should be 2 Groups.")

    networkZones := terraform.OutputList(t, tfOptions, "network_zones")
    assert.Equal(t, len(networkZones), 1, "There should be 1 Network Zone.")
}
