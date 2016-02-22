module.exports = function (grunt) {

	grunt.initConfig({
		pkg: grunt.file.readJSON("package.json"),

		haxe: {
			project: {
				hxml: "build.hxml"
			}
		},

		exec: {
            copy: "mkdir npm-publish || true && cp -r src dist assets package.json LICENSE README.md ./npm-publish/",
			npm: "npm publish ./npm-publish/ && rm -r npm-publish"
		},

		zip: {
			"perf.zip": ["src/**", "haxelib.json", "README.md", "LICENSE"]
		}
	});

	grunt.loadNpmTasks("grunt-haxe");
	grunt.loadNpmTasks("grunt-zip");
	grunt.loadNpmTasks("grunt-exec");
	grunt.registerTask("default", ["haxe", "exec"]);
};