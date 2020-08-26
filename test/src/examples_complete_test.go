package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/qdm12/reprint"
	"github.com/stretchr/testify/assert"
)

type NLContext struct {
	AdditionalTagMap  map[string]string `json:"additional_tag_map"`
	Attributes        []string          `json:"attributes"`
	Delimiter         interface{}       `json:"delimiter"`
	Enabled           bool              `json:"enabled"`
	Environment       interface{}       `json:"environment"`
	LabelOrder        []string          `json:"label_order"`
	Name              interface{}       `json:"name"`
	Namespace         interface{}       `json:"namespace"`
	RegexReplaceChars interface{}       `json:"regex_replace_chars"`
	Stage             interface{}       `json:"stage"`
	Tags              map[string]string `json:"tags"`
}

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

	expectedLabel1Input := NLContext{
		Enabled:     true,
		Namespace:   "CloudPosse",
		Environment: "UAT",
		Stage:       "build",
		Name:        "Winston Churchroom",
		Attributes:  []string{"fire", "water", "earth", "air"},
		Delimiter:   "-",
		LabelOrder:  []string{"name", "environment", "stage", "attributes"},
		Tags: map[string]string{
			"City":        "Dublin",
			"Environment": "Private",
		},
	}

	var expectedLabel1Context NLContext
	_ = reprint.FromTo(&expectedLabel1Input, &expectedLabel1Context)
	expectedLabel1Context.Namespace = "cloudposse"
	expectedLabel1Context.Environment = "uat"
	expectedLabel1Context.Name = "winstonchurchroom"
	expectedLabel1Context.RegexReplaceChars = "/[^-a-zA-Z0-9]/"
	expectedLabel1Context.Tags = map[string]string{
		"City":        "Dublin",
		"Environment": "Private",
		"Namespace":   "cloudposse",
		"Stage":       "build",
		"Name":        "winstonchurchroom-uat-build-fire-water-earth-air",
		"Attributes":  "fire-water-earth-air",
	}

	var label1Context, label1Input NLContext
	// Run `terraform output` to get the value of an output variable
	label1 := terraform.OutputMap(t, terraformOptions, "label1")
	label1Tags := terraform.OutputMap(t, terraformOptions, "label1_tags")
	terraform.OutputStruct(t, terraformOptions, "label1_context", &label1Context)
	terraform.OutputStruct(t, terraformOptions, "label1_input", &label1Input)

	// Verify we're getting back the outputs we expect
	assert.Equal(t, "winstonchurchroom-uat-build-fire-water-earth-air", label1["id"])
	assert.Equal(t, "winstonchurchroom-uat-build-fire-water-earth-air", label1Tags["Name"])
	assert.Equal(t, "Dublin", label1Tags["City"])
	assert.Equal(t, "Private", label1Tags["Environment"])
	assert.Equal(t, expectedLabel1Context, label1Context)
	assert.Equal(t, expectedLabel1Input, label1Input)

	// Run `terraform output` to get the value of an output variable
	label2 := terraform.OutputMap(t, terraformOptions, "label2")
	label2Tags := terraform.OutputMap(t, terraformOptions, "label2_tags")

	// Verify we're getting back the outputs we expect
	assert.Equal(t, "charlie+uat+test+fire+water+earth+air", label2["id"])
	assert.Equal(t, "charlie+uat+test+fire+water+earth+air", label2Tags["Name"])
	assert.Equal(t, "London", label2Tags["City"])
	assert.Equal(t, "Public", label2Tags["Environment"])

	var expectedLabel3cInput, label3cInput NLContext
	_ = reprint.FromTo(&expectedLabel1Context, &expectedLabel3cInput)
	expectedLabel3cInput.Name = "Starfish"
	expectedLabel3cInput.Stage = "release"
	expectedLabel3cInput.Delimiter = "."
	expectedLabel3cInput.RegexReplaceChars = "/[^-a-zA-Z0-9.]/"
	expectedLabel3cInput.Tags["Eat"] = "Carrot"
	expectedLabel3cInput.Tags["Animal"] = "Rabbit"

	// Run `terraform output` to get the value of an output variable
	label3c := terraform.OutputMap(t, terraformOptions, "label3c")
	label3cTags := terraform.OutputMap(t, terraformOptions, "label3c_tags")
	terraform.OutputStruct(t, terraformOptions, "label3c_input", &label3cInput)

	// Verify we're getting back the outputs we expect
	assert.Equal(t, "starfish.uat.release.fire.water.earth.air", label3c["id"])
	assert.Equal(t, "starfish.uat.release.fire.water.earth.air", label3cTags["Name"])
	assert.Equal(t, expectedLabel3cInput, label3cInput)

	var expectedLabel3iInput, label3iInput NLContext
	_ = reprint.FromTo(&expectedLabel1Input, &expectedLabel3cInput)
	expectedLabel3iInput.Name = "Starfish"
	expectedLabel3iInput.Stage = "release"
	expectedLabel3iInput.Delimiter = "."
	expectedLabel3iInput.RegexReplaceChars = "/[^-a-zA-Z0-9.]/"
	expectedLabel3iInput.Tags["Eat"] = "Carrot"
	expectedLabel3iInput.Tags["Animal"] = "Rabbit"

	// Run `terraform output` to get the value of an output variable
	label3i := terraform.OutputMap(t, terraformOptions, "label3i")
	label3iTags := terraform.OutputMap(t, terraformOptions, "label3i_tags")
	terraform.OutputStruct(t, terraformOptions, "label3i_input", &label3iInput)

	// Verify we're getting back the outputs we expect
	assert.Equal(t, "starfish.uat.release.fire.water.earth.air", label3i["id"])
	assert.Equal(t, "starfish.uat.release.fire.water.earth.air", label3iTags["Name"])
	assert.Equal(t, expectedLabel3iInput, label3iInput)

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
