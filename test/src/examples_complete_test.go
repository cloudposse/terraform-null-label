package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

// Test the Terraform module in examples/complete using Terratest.
func TestExamplesComplete(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../../examples/complete",
		Upgrade:      true,
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)

	// Run `terraform output` to get the value of an output variable
	label1 := terraform.OutputMap(t, terraformOptions, "label1")
	label1Tags := terraform.OutputMap(t, terraformOptions, "label1_tags")

	// Verify we're getting back the outputs we expect
	assert.Equal(t, "winstonchurchroom-uat-build-fire-water-earth-air", label1["id"])
	assert.Equal(t, "winstonchurchroom-uat-build-fire-water-earth-air", label1Tags["Name"])

	// Run `terraform output` to get the value of an output variable
	label2 := terraform.OutputMap(t, terraformOptions, "label2")
	label2Tags := terraform.OutputMap(t, terraformOptions, "label2_tags")

	// Verify we're getting back the outputs we expect
	assert.Equal(t, "charlie+uat+test+fire+water+earth+air", label2["id"])
	assert.Equal(t, "charlie+uat+test+fire+water+earth+air", label2Tags["Name"])

	// Run `terraform output` to get the value of an output variable
	label3 := terraform.OutputMap(t, terraformOptions, "label3")
	label3Tags := terraform.OutputMap(t, terraformOptions, "label3_tags")

	// Verify we're getting back the outputs we expect
	assert.Equal(t, "starfish.uat.release.fire.water.earth.air", label3["id"])
	assert.Equal(t, "starfish.uat.release.fire.water.earth.air", label3Tags["Name"])

	// Run `terraform output` to get the value of an output variable
	label4 := terraform.OutputMap(t, terraformOptions, "label4")
	label4Tags := terraform.OutputMap(t, terraformOptions, "label4_tags")

	// Verify we're getting back the outputs we expect
	assert.Equal(t, "cloudposse-uat-big-fat-honking-cluster", label4["id"])
	assert.Equal(t, "cloudposse-uat-big-fat-honking-cluster", label4Tags["Name"])

	// Run `terraform output` to get the value of an output variable
	label5 := terraform.OutputMap(t, terraformOptions, "label5")

	// Verify we're getting back the outputs we expect
	assert.Equal(t, "", label5["id"])
}
