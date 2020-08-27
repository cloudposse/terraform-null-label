package test

import (
	"fmt"
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

	expectedLabel1Context := NLContext{
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
		AdditionalTagMap: map[string]string{},
	}

	var expectedLabel1NormalizedContext NLContext
	_ = reprint.FromTo(&expectedLabel1Context, &expectedLabel1NormalizedContext)
	expectedLabel1NormalizedContext.Namespace = "cloudposse"
	expectedLabel1NormalizedContext.Environment = "uat"
	expectedLabel1NormalizedContext.Name = "winstonchurchroom"
	expectedLabel1NormalizedContext.RegexReplaceChars = "/[^-a-zA-Z0-9]/"
	expectedLabel1NormalizedContext.Tags = map[string]string{
		"City":        "Dublin",
		"Environment": "Private",
		"Namespace":   "cloudposse",
		"Stage":       "build",
		"Name":        "winstonchurchroom-uat-build-fire-water-earth-air",
		"Attributes":  "fire-water-earth-air",
	}

	var label1NormalizedContext, label1Context NLContext
	// Run `terraform output` to get the value of an output variable
	label1 := terraform.OutputMap(t, terraformOptions, "label1")
	label1Tags := terraform.OutputMap(t, terraformOptions, "label1_tags")
	terraform.OutputStruct(t, terraformOptions, "label1_normalized_context", &label1NormalizedContext)
	terraform.OutputStruct(t, terraformOptions, "label1_context", &label1Context)

	// Verify we're getting back the outputs we expect
	assert.Equal(t, "winstonchurchroom-uat-build-fire-water-earth-air", label1["id"])
	assert.Equal(t, "winstonchurchroom-uat-build-fire-water-earth-air", label1Tags["Name"])
	assert.Equal(t, "Dublin", label1Tags["City"])
	assert.Equal(t, "Private", label1Tags["Environment"])
	assert.Equal(t, expectedLabel1NormalizedContext, label1NormalizedContext)
	assert.Equal(t, expectedLabel1Context, label1Context)

	label1t1 := terraform.OutputMap(t, terraformOptions, "label1t1")
	label1t1Tags := terraform.OutputMap(t, terraformOptions, "label1t1_tags")
	assert.Equal(t, "winstonchurchroom-uat-6a0b34", label1t1["id"],
		"Extra hash character should be added when trailing delimiter is removed")
	assert.Equal(t, label1["id"], label1t1["id_full"], "id_full should not be truncated")
	assert.Equal(t, label1t1["id"], label1t1Tags["Name"], "Name tag should match ID")

	label1t2 := terraform.OutputMap(t, terraformOptions, "label1t2")
	label1t2Tags := terraform.OutputMap(t, terraformOptions, "label1t2_tags")
	assert.Equal(t, "winstonchurchroom-uat-b-6a0b3", label1t2["id"])
	assert.Equal(t, label1t2["id"], label1t2Tags["Name"], "Name tag should match ID")

	// Run `terraform output` to get the value of an output variable
	label2 := terraform.OutputMap(t, terraformOptions, "label2")
	label2Tags := terraform.OutputMap(t, terraformOptions, "label2_tags")

	// Verify we're getting back the outputs we expect
	assert.Equal(t, "charlie+uat+test+fire+water+earth+air", label2["id"])
	assert.Equal(t, "charlie+uat+test+fire+water+earth+air", label2Tags["Name"])
	assert.Equal(t, "London", label2Tags["City"])
	assert.Equal(t, "Public", label2Tags["Environment"])

	var expectedLabel3cContext, label3cContext NLContext
	_ = reprint.FromTo(&expectedLabel1Context, &expectedLabel3cContext)
	expectedLabel3cContext.Name = "Starfish"
	expectedLabel3cContext.Stage = "release"
	expectedLabel3cContext.Delimiter = "."
	expectedLabel3cContext.RegexReplaceChars = "/[^-a-zA-Z0-9.]/"
	expectedLabel3cContext.Tags["Eat"] = "Carrot"
	expectedLabel3cContext.Tags["Animal"] = "Rabbit"

	// Run `terraform output` to get the value of an output variable
	label3c := terraform.OutputMap(t, terraformOptions, "label3c")
	label3cTags := terraform.OutputMap(t, terraformOptions, "label3c_tags")
	terraform.OutputStruct(t, terraformOptions, "label3c_context", &label3cContext)

	// Verify we're getting back the outputs we expect
	assert.Equal(t, "starfish.uat.release.fire.water.earth.air", label3c["id"])
	assert.Equal(t, "starfish.uat.release.fire.water.earth.air", label3cTags["Name"])
	assert.Equal(t, expectedLabel3cContext, label3cContext)

	var expectedLabel3nContext, label3nContext NLContext
	_ = reprint.FromTo(&expectedLabel1NormalizedContext, &expectedLabel3nContext)
	expectedLabel3nContext.Name = "Starfish"
	expectedLabel3nContext.Stage = "release"
	expectedLabel3nContext.Delimiter = "."
	expectedLabel3nContext.RegexReplaceChars = "/[^-a-zA-Z0-9.]/"
	expectedLabel3nContext.Tags["Eat"] = "Carrot"
	expectedLabel3nContext.Tags["Animal"] = "Rabbit"

	// Run `terraform output` to get the value of an output variable
	label3n := terraform.OutputMap(t, terraformOptions, "label3n")
	label3nTags := terraform.OutputMap(t, terraformOptions, "label3n_tags")
	terraform.OutputStruct(t, terraformOptions, "label3n_context", &label3nContext)

	// Verify we're getting back the outputs we expect
	assert.Equal(t, "starfish.uat.release.fire.water.earth.air", label3n["id"])
	assert.Equal(t, label1Tags["Name"], label3nTags["Name"],
		"Tag from label1 normalized context should overwrite label3n generated tag")
	assert.Equal(t, expectedLabel3nContext, label3nContext)

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

	label6f := terraform.OutputMap(t, terraformOptions, "label6f")
	label6fTags := terraform.OutputMap(t, terraformOptions, "label6f_tags")
	assert.Equal(t, "cp~uw2~prd~null-label", label6f["id_full"])
	assert.Equal(t, label6f["id_full"], label6f["id"], "id should not be truncated")
	assert.Equal(t, label6f["id"], label6fTags["Name"], "Name tag should match ID")

	label6t := terraform.OutputMap(t, terraformOptions, "label6t")
	label6tTags := terraform.OutputMap(t, terraformOptions, "label6t_tags")
	assert.Equal(t, "cpuw2prdnull-label", label6t["id_full"])
	assert.NotEqual(t, label6t["id_full"], label6t["id"], "id should be truncated")
	assert.Equal(t, label6t["id"], label6tTags["Name"], "Name tag should match ID")
	assert.Equal(t, label6t["id_length_limit"], fmt.Sprintf("%d", len(label6t["id"])),
		"Truncated ID length should equal length limit")

}
