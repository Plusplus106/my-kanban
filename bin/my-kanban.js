#!/usr/bin/env node

const fileSystem = require('fs');

const operatingSystem = require('os');

const pathModule = require('path');

const packageJson = require('../package.json');

const REPOSITORY_ROOT = pathModule.resolve(__dirname, '..');
const DEFAULT_LOCALE = 'zh-TW';
const DEFAULT_TARGETS = ['claude', 'gpt', 'gemini'];

const KANBAN_STAGE_DIRECTORIES = [
  '0-Epics',
  '1-Specs',
  '2-Plans',
  '3-Progressing',
  '4-Testing',
  '5-Re-testing',
  '6-On-hold',
  '7-Done',
  '8-Archived',
];

/**
 * Print a message to standard output.
 * @param {string} message - Message text to display.
 */
function printOutput(message) {
  // eslint-disable-next-line no-console
  console.log(message);
}

/**
 * Print an error message to standard error.
 * @param {string} message - Error text to display.
 */
function printError(message) {
  // eslint-disable-next-line no-console
  console.error(message);
}

/**
 * Normalize a target alias into a canonical target name.
 * @param {string} rawTargetName - Raw target name from CLI arguments.
 * @returns {string|null} Canonical target name ('claude', 'gpt', 'gemini') or null.
 */
function normalizeTargetName(rawTargetName) {
  const normalizedValue = String(rawTargetName || '').trim().toLowerCase();

  if (normalizedValue === 'claude' || normalizedValue === 'claude-code') {
    return 'claude';
  }

  if (
    normalizedValue === 'gpt'
    || normalizedValue === 'codex'
    || normalizedValue === 'openai'
  ) {
    return 'gpt';
  }

  if (
    normalizedValue === 'gemini'
    || normalizedValue === 'antigravity'
    || normalizedValue === 'gemini-cli'
  ) {
    return 'gemini';
  }

  return null;
}

/**
 * Resolve target skill directories for a given AI tool target and scope.
 * @param {string} targetName - Canonical target name ('claude', 'gpt', 'gemini').
 * @param {string} scopeMode - 'global' or 'project'.
 * @param {string} homeDirectory - User home directory path.
 * @param {string} workingDirectory - Current working directory path.
 * @returns {string[]} Array of target skill root directory paths.
 */
function resolveTargetDirectories(
  targetName,
  scopeMode,
  homeDirectory,
  workingDirectory,
) {
  const isProjectScope = scopeMode === 'project';
  const baseDirectory = isProjectScope ? workingDirectory : homeDirectory;

  if (targetName === 'claude') {
    return [pathModule.join(baseDirectory, '.claude', 'skills')];
  }

  if (targetName === 'gpt') {
    return [pathModule.join(baseDirectory, '.codex', 'skills')];
  }

  if (targetName === 'gemini') {
    if (isProjectScope) {
      return [
        pathModule.join(baseDirectory, '.agents', 'skills'),
        pathModule.join(baseDirectory, '.gemini', 'skills'),
      ];
    }

    return [
      pathModule.join(baseDirectory, '.gemini', 'config', 'skills'),
      pathModule.join(baseDirectory, '.gemini', 'skills'),
    ];
  }

  return [];
}

/**
 * Parse command-line arguments into structured CLI options.
 * @param {string[]} commandLineArguments - Raw process arguments after node and script.
 * @returns {object} Parsed command and option flags.
 */
function parseCommandLineArguments(commandLineArguments) {
  const options = {
    command: 'install',
    locale: DEFAULT_LOCALE,
    scope: 'global',
    targets: [...DEFAULT_TARGETS],
    skillNames: [],
    useSymlink: false,
    projectName: null,
    showHelp: false,
    showVersion: false,
  };

  const customTargets = [];
  let hasExplicitCommand = false;

  for (let index = 0; index < commandLineArguments.length; index += 1) {
    const currentArgument = commandLineArguments[index];

    if (currentArgument === '--help' || currentArgument === '-h' || currentArgument === 'help') {
      options.showHelp = true;
    } else if (
      currentArgument === '--version'
      || currentArgument === '-v'
      || currentArgument === 'version'
    ) {
      options.showVersion = true;
    } else if (
      !hasExplicitCommand
      && (
        currentArgument === 'install'
        || currentArgument === 'uninstall'
        || currentArgument === 'remove'
        || currentArgument === 'list'
        || currentArgument === 'init'
      )
    ) {
      hasExplicitCommand = true;
      options.command = currentArgument === 'remove' ? 'uninstall' : currentArgument;

      if (options.command === 'init') {
        const nextArgument = commandLineArguments[index + 1];

        if (nextArgument && !nextArgument.startsWith('-')) {
          options.projectName = nextArgument;
          index += 1;
        }
      }
    } else if (currentArgument === '--global' || currentArgument === '-g') {
      options.scope = 'global';
    } else if (currentArgument === '--project' || currentArgument === '-p') {
      options.scope = 'project';
    } else if (currentArgument === '--symlink' || currentArgument === '--link') {
      options.useSymlink = true;
    } else if (
      currentArgument === '--lang'
      || currentArgument === '--locale'
      || currentArgument === '-l'
    ) {
      const localeValue = commandLineArguments[index + 1];

      if (localeValue) {
        options.locale = localeValue;
        index += 1;
      }
    } else if (currentArgument.startsWith('--lang=')) {
      options.locale = currentArgument.slice('--lang='.length);
    } else if (currentArgument.startsWith('--locale=')) {
      options.locale = currentArgument.slice('--locale='.length);
    } else if (
      currentArgument === '--targets'
      || currentArgument === '--target'
      || currentArgument === '--agent'
      || currentArgument === '-t'
      || currentArgument === '-a'
    ) {
      const targetValue = commandLineArguments[index + 1];

      if (targetValue) {
        targetValue.split(',').forEach((item) => {
          customTargets.push(item);
        });
        index += 1;
      }
    } else if (
      currentArgument.startsWith('--targets=')
      || currentArgument.startsWith('--target=')
      || currentArgument.startsWith('--agent=')
    ) {
      const equalIndex = currentArgument.indexOf('=');
      const targetValue = currentArgument.slice(equalIndex + 1);
      targetValue.split(',').forEach((item) => {
        customTargets.push(item);
      });
    } else if (currentArgument === '--skill' || currentArgument === '-s') {
      const skillValue = commandLineArguments[index + 1];

      if (skillValue) {
        skillValue.split(',').forEach((item) => {
          const trimmedSkillName = item.trim();

          if (trimmedSkillName) {
            options.skillNames.push(trimmedSkillName);
          }
        });
        index += 1;
      }
    } else if (currentArgument.startsWith('--skill=')) {
      const skillValue = currentArgument.slice('--skill='.length);
      skillValue.split(',').forEach((item) => {
        const trimmedSkillName = item.trim();

        if (trimmedSkillName) {
          options.skillNames.push(trimmedSkillName);
        }
      });
    }
  }

  if (customTargets.length > 0) {
    const resolvedTargets = [];

    customTargets.forEach((rawTarget) => {
      const loweredTarget = String(rawTarget).trim().toLowerCase();

      if (loweredTarget === 'all') {
        DEFAULT_TARGETS.forEach((defaultTarget) => {
          if (!resolvedTargets.includes(defaultTarget)) {
            resolvedTargets.push(defaultTarget);
          }
        });
      } else {
        const canonicalTarget = normalizeTargetName(loweredTarget);

        if (canonicalTarget && !resolvedTargets.includes(canonicalTarget)) {
          resolvedTargets.push(canonicalTarget);
        }
      }
    });

    if (resolvedTargets.length > 0) {
      options.targets = resolvedTargets;
    }
  }

  return options;
}

/**
 * Extract name and description from SKILL.md YAML frontmatter.
 * @param {string} skillMarkdownPath - Path to SKILL.md file.
 * @returns {{ name: string, description: string }} Metadata object.
 */
function parseSkillMetadata(skillMarkdownPath) {
  const fileContent = fileSystem.readFileSync(skillMarkdownPath, 'utf8');
  const frontmatterMatch = fileContent.match(/^---\r?\n([\s\S]*?)\r?\n---/);

  if (!frontmatterMatch) {
    return { name: '', description: '' };
  }

  const frontmatterBlock = frontmatterMatch[1];
  const nameMatch = frontmatterBlock.match(/^name:\s*(.+)$/m);
  const descriptionMatch = frontmatterBlock.match(/^description:\s*(.+)$/m);

  return {
    name: nameMatch ? nameMatch[1].trim() : '',
    description: descriptionMatch ? descriptionMatch[1].trim() : '',
  };
}

/**
 * Discover all available skills under a given locale directory.
 * @param {string} repositoryRoot - Root path of my-kanban repository.
 * @param {string} localeName - Locale directory name (e.g., 'zh-TW').
 * @returns {Array<{ folderName: string, skillPath: string, description: string }>} Skill list.
 */
function discoverSkills(repositoryRoot, localeName) {
  const skillsRootDirectory = pathModule.join(repositoryRoot, localeName, 'skills');

  if (!fileSystem.existsSync(skillsRootDirectory)) {
    throw new Error(`Locale skills directory not found: ${skillsRootDirectory}`);
  }

  const directoryEntries = fileSystem.readdirSync(skillsRootDirectory, { withFileTypes: true });
  const discoveredSkills = [];

  directoryEntries.forEach((directoryEntry) => {
    if (directoryEntry.isDirectory()) {
      const skillDirectoryPath = pathModule.join(skillsRootDirectory, directoryEntry.name);
      const skillMarkdownPath = pathModule.join(skillDirectoryPath, 'SKILL.md');

      if (fileSystem.existsSync(skillMarkdownPath)) {
        const metadata = parseSkillMetadata(skillMarkdownPath);
        discoveredSkills.push({
          folderName: directoryEntry.name,
          skillPath: skillDirectoryPath,
          description: metadata.description,
        });
      }
    }
  });

  discoveredSkills.sort((firstSkill, secondSkill) => (
    firstSkill.folderName.localeCompare(secondSkill.folderName)
  ));

  return discoveredSkills;
}

/**
 * Check whether two paths resolve to the exact same physical filesystem path.
 * @param {string} firstPath - First filesystem path.
 * @param {string} secondPath - Second filesystem path.
 * @returns {boolean} True when both paths exist and resolve to the same realpath.
 */
function isSameRealPath(firstPath, secondPath) {
  try {
    const firstRealPath = fileSystem.realpathSync(firstPath);
    const secondRealPath = fileSystem.realpathSync(secondPath);

    return firstRealPath === secondRealPath;
  } catch (error) {
    return false;
  }
}

/**
 * Check whether a path exists on disk (including broken symlinks).
 * @param {string} targetPath - Filesystem path to inspect.
 * @returns {boolean} True if path or symlink entry exists.
 */
function pathEntryExists(targetPath) {
  try {
    fileSystem.lstatSync(targetPath);

    return true;
  } catch (error) {
    return false;
  }
}

/**
 * Install a single skill into a destination directory.
 * @param {object} parameters - Installation parameters.
 * @param {string} parameters.skillFolderName - Name of the skill folder.
 * @param {string} parameters.sourceSkillPath - Absolute path to the source skill directory.
 * @param {string} parameters.sourceTemplatesPath - Absolute path to the locale templates directory.
 * @param {string} parameters.destinationRootDirectory - Target skills root directory.
 * @param {boolean} parameters.useSymlink - Whether to symlink instead of copying.
 * @returns {{ status: string, destinationSkillPath: string }} Installation result.
 */
function installSingleSkill({
  skillFolderName,
  sourceSkillPath,
  sourceTemplatesPath,
  destinationRootDirectory,
  useSymlink,
}) {
  fileSystem.mkdirSync(destinationRootDirectory, { recursive: true });
  const destinationSkillPath = pathModule.join(destinationRootDirectory, skillFolderName);

  const alreadyPointsToSource = isSameRealPath(destinationSkillPath, sourceSkillPath);

  if (alreadyPointsToSource) {
    return {
      status: 'already-linked',
      destinationSkillPath,
    };
  }

  const destinationEntryExists = pathEntryExists(destinationSkillPath);

  if (destinationEntryExists) {
    fileSystem.rmSync(destinationSkillPath, { recursive: true, force: true });
  }

  if (useSymlink) {
    fileSystem.symlinkSync(sourceSkillPath, destinationSkillPath, 'dir');

    return {
      status: 'symlinked',
      destinationSkillPath,
    };
  }

  fileSystem.cpSync(sourceSkillPath, destinationSkillPath, {
    recursive: true,
    dereference: true,
  });

  const embeddedTemplatesPath = pathModule.join(destinationSkillPath, 'templates');
  const templatesExists = fileSystem.existsSync(sourceTemplatesPath);

  if (templatesExists) {
    const embeddedEntryExists = pathEntryExists(embeddedTemplatesPath);

    if (embeddedEntryExists) {
      const embeddedStatistics = fileSystem.lstatSync(embeddedTemplatesPath);

      if (embeddedStatistics.isSymbolicLink()) {
        fileSystem.rmSync(embeddedTemplatesPath, { recursive: true, force: true });
      }
    }

    if (!fileSystem.existsSync(embeddedTemplatesPath)) {
      fileSystem.cpSync(sourceTemplatesPath, embeddedTemplatesPath, {
        recursive: true,
        dereference: true,
      });
    }
  }

  return {
    status: 'copied',
    destinationSkillPath,
  };
}

/**
 * Install my-kanban skills across selected AI tool targets.
 * @param {object} options - Parsed CLI options.
 * @param {object} environmentPaths - Optional custom paths for testing.
 * @returns {{ installedCount: number, targetDirectories: string[] }} Summary.
 */
function executeInstallCommand(options, environmentPaths = {}) {
  const repositoryRoot = environmentPaths.repositoryRoot || REPOSITORY_ROOT;
  const homeDirectory = environmentPaths.homeDirectory || operatingSystem.homedir();
  const workingDirectory = environmentPaths.workingDirectory || process.cwd();

  const allSkills = discoverSkills(repositoryRoot, options.locale);
  const selectedSkills = options.skillNames.length > 0
    ? allSkills.filter((skillItem) => options.skillNames.includes(skillItem.folderName))
    : allSkills;

  if (selectedSkills.length === 0) {
    throw new Error(`No matching skills found for locale "${options.locale}".`);
  }

  const sourceTemplatesPath = pathModule.join(repositoryRoot, options.locale, 'templates');
  const allTargetDirectories = [];

  options.targets.forEach((targetName) => {
    const resolvedDirectories = resolveTargetDirectories(
      targetName,
      options.scope,
      homeDirectory,
      workingDirectory,
    );
    resolvedDirectories.forEach((directoryPath) => {
      if (!allTargetDirectories.includes(directoryPath)) {
        allTargetDirectories.push(directoryPath);
      }
    });
  });

  let installedCount = 0;

  printOutput(
    `🚀 Installing ${selectedSkills.length} my-kanban skills (locale: ${options.locale}, scope: ${options.scope})...`,
  );

  allTargetDirectories.forEach((destinationRootDirectory) => {
    printOutput(`\n📂 Target directory: ${destinationRootDirectory}`);

    selectedSkills.forEach((skillItem) => {
      const installationResult = installSingleSkill({
        skillFolderName: skillItem.folderName,
        sourceSkillPath: skillItem.skillPath,
        sourceTemplatesPath,
        destinationRootDirectory,
        useSymlink: options.useSymlink,
      });
      installedCount += 1;
      printOutput(`  ✅ ${skillItem.folderName} (${installationResult.status})`);
    });
  });

  printOutput('\n✨ Installation complete! Trigger in Claude / GPT / Gemini with $kanban-skill-selector');

  return {
    installedCount,
    targetDirectories: allTargetDirectories,
  };
}

/**
 * Uninstall my-kanban skills from selected AI tool targets.
 * @param {object} options - Parsed CLI options.
 * @param {object} environmentPaths - Optional custom paths for testing.
 * @returns {{ removedCount: number, targetDirectories: string[] }} Summary.
 */
function executeUninstallCommand(options, environmentPaths = {}) {
  const repositoryRoot = environmentPaths.repositoryRoot || REPOSITORY_ROOT;
  const homeDirectory = environmentPaths.homeDirectory || operatingSystem.homedir();
  const workingDirectory = environmentPaths.workingDirectory || process.cwd();

  const allSkills = discoverSkills(repositoryRoot, options.locale);
  const selectedSkills = options.skillNames.length > 0
    ? allSkills.filter((skillItem) => options.skillNames.includes(skillItem.folderName))
    : allSkills;

  const allTargetDirectories = [];

  options.targets.forEach((targetName) => {
    const resolvedDirectories = resolveTargetDirectories(
      targetName,
      options.scope,
      homeDirectory,
      workingDirectory,
    );
    resolvedDirectories.forEach((directoryPath) => {
      if (!allTargetDirectories.includes(directoryPath)) {
        allTargetDirectories.push(directoryPath);
      }
    });
  });

  let removedCount = 0;

  allTargetDirectories.forEach((destinationRootDirectory) => {
    selectedSkills.forEach((skillItem) => {
      const destinationSkillPath = pathModule.join(destinationRootDirectory, skillItem.folderName);
      const existsOnDisk = pathEntryExists(destinationSkillPath);

      if (existsOnDisk) {
        fileSystem.rmSync(destinationSkillPath, { recursive: true, force: true });
        removedCount += 1;
        printOutput(`🗑️  Removed: ${destinationSkillPath}`);
      }
    });
  });

  printOutput(`✨ Uninstall complete (${removedCount} entries removed).`);

  return {
    removedCount,
    targetDirectories: allTargetDirectories,
  };
}

/**
 * List all available skills in my-kanban.
 * @param {object} options - Parsed CLI options.
 * @param {object} environmentPaths - Optional custom paths for testing.
 * @returns {Array<{ folderName: string, skillPath: string, description: string }>} Skills.
 */
function executeListCommand(options, environmentPaths = {}) {
  const repositoryRoot = environmentPaths.repositoryRoot || REPOSITORY_ROOT;
  const discoveredSkills = discoverSkills(repositoryRoot, options.locale);

  printOutput(`📋 Available my-kanban skills (${options.locale}) — total ${discoveredSkills.length}:\n`);
  discoveredSkills.forEach((skillItem) => {
    printOutput(`  • $${skillItem.folderName}`);
    if (skillItem.description) {
      printOutput(`    ${skillItem.description}`);
    }
  });

  return discoveredSkills;
}

/**
 * Initialize a new Kanban project folder structure.
 * @param {object} options - Parsed CLI options.
 * @param {object} environmentPaths - Optional custom paths for testing.
 * @returns {string} Created project directory path.
 */
function executeInitCommand(options, environmentPaths = {}) {
  const workingDirectory = environmentPaths.workingDirectory || process.cwd();

  if (!options.projectName) {
    throw new Error('Project name is required. Usage: my-kanban init <project-name>');
  }

  const projectDirectoryPath = pathModule.resolve(workingDirectory, options.projectName);

  if (fileSystem.existsSync(projectDirectoryPath)) {
    throw new Error(`Project directory already exists: ${projectDirectoryPath}`);
  }

  KANBAN_STAGE_DIRECTORIES.forEach((stageName) => {
    const stageDirectoryPath = pathModule.join(projectDirectoryPath, stageName);
    fileSystem.mkdirSync(stageDirectoryPath, { recursive: true });
  });

  printOutput(`✅ Initialized Kanban project structure at: ${projectDirectoryPath}`);

  return projectDirectoryPath;
}

/**
 * Print CLI usage help message.
 */
function printHelpMessage() {
  const helpText = `
my-kanban v${packageJson.version} — Multi-AI Kanban Skill Installer & CLI

Usage:
  npx github:Plusplus106/my-kanban [command] [options]
  my-kanban [command] [options]

Commands:
  install                 Install skills to Claude, GPT (Codex), and Gemini (default)
  uninstall               Remove installed my-kanban skills
  list                    List all available skills in my-kanban
  init <project-name>     Create Kanban stage folders (0-Epics .. 8-Archived)

Options:
  -t, --targets <list>    Comma-separated AI tools: claude,gpt,gemini,all (default: all)
  -g, --global            Install to global AI tool directories (default)
  -p, --project           Install to current project workspace (.claude, .codex, .agents)
  -l, --lang <locale>     Locale content root (default: zh-TW)
  -s, --skill <name>      Install/uninstall only specific skill(s), comma-separated
      --symlink           Use symlinks instead of copying standalone skill folders
  -v, --version           Show version number
  -h, --help              Show this help message

Examples:
  # Install to Claude Code, OpenAI Codex (GPT), and Gemini globally in one command
  npx github:Plusplus106/my-kanban install

  # Install into the current project workspace only
  npx github:Plusplus106/my-kanban install --project

  # Install only for Claude and Gemini
  npx github:Plusplus106/my-kanban install --targets claude,gemini
`.trim();

  printOutput(helpText);
}

/**
 * Run the CLI with given arguments.
 * @param {string[]} commandLineArguments - Raw CLI arguments.
 * @param {object} environmentPaths - Optional custom paths for testing.
 * @returns {number} Process exit code.
 */
function runCli(commandLineArguments = process.argv.slice(2), environmentPaths = {}) {
  try {
    const parsedOptions = parseCommandLineArguments(commandLineArguments);

    if (parsedOptions.showVersion) {
      printOutput(packageJson.version);

      return 0;
    }

    if (parsedOptions.showHelp) {
      printHelpMessage();

      return 0;
    }

    if (parsedOptions.command === 'list') {
      executeListCommand(parsedOptions, environmentPaths);

      return 0;
    }

    if (parsedOptions.command === 'uninstall') {
      executeUninstallCommand(parsedOptions, environmentPaths);

      return 0;
    }

    if (parsedOptions.command === 'init') {
      executeInitCommand(parsedOptions, environmentPaths);

      return 0;
    }

    executeInstallCommand(parsedOptions, environmentPaths);

    return 0;
  } catch (error) {
    printError(`❌ Error: ${error.message}`);

    return 1;
  }
}

if (require.main === module) {
  const exitCode = runCli();
  process.exitCode = exitCode;
}

module.exports = {
  DEFAULT_LOCALE,
  DEFAULT_TARGETS,
  KANBAN_STAGE_DIRECTORIES,
  discoverSkills,
  executeInitCommand,
  executeInstallCommand,
  executeListCommand,
  executeUninstallCommand,
  installSingleSkill,
  normalizeTargetName,
  parseCommandLineArguments,
  parseSkillMetadata,
  resolveTargetDirectories,
  runCli,
};
