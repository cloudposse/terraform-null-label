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
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)

	// Run `terraform output` to get the value of an output variable
	label1 := terraform.OutputMap(t, terraformOptions, "label1")

	// Verify we're getting back the outputs we expect
	assert.Equal(t, "winstonchurchroom-uat-build-fire-water-earth-air", label1["id"])

	// Run `terraform output` to get the value of an output variable
	label2 := terraform.OutputMap(t, terraformOptions, "label2")

	// Verify we're getting back the outputs we expect
	assert.Equal(t, "charlie+uat+test+fire+water+earth+air", label2["id"])

	// Run `terraform output` to get the value of an output variable
	label3 := terraform.OutputMap(t, terraformOptions, "label3")

	// Verify we're getting back the outputs we expect
	assert.Equal(t, "starfish.uat.release.fire.water.earth.air", label3["id"])
}
