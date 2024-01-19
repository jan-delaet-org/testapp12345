const repositoryUrl = process.env.REPOSITORY_URL;
const dockerImage = process.env.DOCKER_IMAGE;
const dockerContext = process.env.DOCKER_BUILD_CONTEXT ?? ".";
const dockerFile = process.env.DOCKER_FILE ?? "Dockerfile";
const dockerRegistry = process.env.DOCKER_REGISTRY;
const dockerProject = process.env.DOCKER_PROJECT;
const dockerPlatform = process.env.DOCKER_PLATFORM ?? "linux/amd64";

const plugins = [
    "@semantic-release/commit-analyzer",
    "@semantic-release/release-notes-generator",
    "@semantic-release/changelog",
    {
        changelogFile: "CHANGELOG.md",
        changelogTitle: "# Changelog",
    },
    [
        "semantic-release-helm",
        {
            chartPath: `./helm/${dockerImage}`,
            onlyUpdateVersion: false,
        },
    ],
    [
        "@codedependant/semantic-release-docker",
        {
            dockerTags: ["{{version}}"],
            dockerImage: dockerImage,
            dockerContext: dockerContext,
            dockerFile: dockerFile,
            dockerRegistry: dockerRegistry,
            dockerProject: dockerProject,
            dockerBuildFlags: {
                platform: dockerPlatform,
            },
            dockerLogin: false,
        },
    ],
    [
        "@semantic-release/git",
        {
            assets: ["CHANGELOG.md", `helm/${dockerImage}/Chart.yaml`],
            message:
                "chore(release): ${nextRelease.version} [skip ci]\n\n${nextRelease.notes}",
        },
    ],
    "@semantic-release/github",
];

module.exports = {
    repositoryUrl: repositoryUrl,
    branches: [
        "main",
        { name: "beta", prerelease: true },
        { name: "alpha", prerelease: true },
    ],
    ci: true,
    dryRun: false,
    plugins: plugins,
};