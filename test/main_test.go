package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestTerraformOktaAppSignonPolicy(t *testing.T) {
	tfOptions := &terraform.Options{
		TerraformDir: "../",
		Vars: map[string]interface{}{
			"name": "test policy",
			"description": "test policy description",
			"rules": []map[string]interface{}{
                {
                    "name": "test rule",
                    "access": "ALLOW",
                    "network_zones": []string{"nzo98czx2D4vRb6VQ1d5", "nzodbozfphekSB8kz1d7"},
                    "step_up_auth": true,
                    "auth_frequency": "daily",
                    "group_targets": []string{"00gj0yu1ezTEHw1w81d7"},
                    "group_exclusions": []string{"00g2p34020fhFdSKE1d7"},
                    "unmanaged_device": []string{"ios", "windows"},
                    "phishing_resistant": true,
			    },
			},
		},
	}

	defer terraform.Destroy(t, tfOptions)
	terraform.InitAndApply(t, tfOptions)

	policyID := terraform.Output(t, tfOptions, "authentication_policy_id")
	assert.NotEmpty(t, policyID, "Policy ID should not be empty")

	policyRules := terraform.OutputList(t, tfOptions, "authentication_policy_rules")
	assert.Equal(t, len(policyRules), 1, "Policy rules should be 1")

	networkZones := terraform.OutputList(t, tfOptions, "network_zones")
	assert.Equal(t, len(networkZones), 2, "Network zones should be 2")
}
