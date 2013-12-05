# watson-perl
### an inline issue manager

[watson](http://goosecode.com/watson) ([mirror](http://nhmood.github.io/watson-perl)) is a tool for creating and tracking bug reports, issues, and internal notes in code.
It is avaliable in two flavors, [watson-ruby](http://github.com/nhmood/watson-ruby) and [watson-perl](http://github.com/nhmood/watson-perl)

### See watson in action [here](http://goosecode.com/watson) ([mirror](http://nhmood.github.io/watson-perl))

## Installation

watson-perl should run on perl 5.10 or later. The following installation procedure is currently recommended:

 1.  Clone the Git repository onto your machine:

     -  Stable: `$ git clone https://github.com/nhmood/watson-perl.git`
     -  Unstable: `$ git clone https://github.com/latk/watson-perl.git`

 2. Install `cpanm` if you don't already have it:

        $ curl -L http://cpanmin.us | perl - App::cpanminus

    If you don't have curl but wget, replace `curl -L` with `wget -O -`. For more details, visit [`App::cpanminus`](https://metacpan.org/pod/App::cpanminus) on CPAN.

 3. Install the dependencies:

        $ cd watson-perl
        $ cpanm --installdeps .

 4. Make `watson` executable:

        $ chmod +x watson

 5. Put `watson` into your `$PATH`, e.g. by linking from `/usr/bin`:

        $ sudo ln -s "`pwd`watson" /usr/bin

To update such an installation, perform `$ git pull` inside the directory.

Other installation modes are planned for the future. Drop a pull request on GitHub if you've figured out how to do this.

## Usage

For a quick idea of how to use watson, check out the [app demo](http://goosecode.com/watson)! ([mirror](http://nhmood.github.io/watson-perl))
See below for a description of what all the command line arguments do.

## Command line arguments
```
Usage: watson [OPTION]...
Running watson with no arguments will parse with settings in RC file
If no RC file exists, default RC file will be created

   -d, --dirs                   list of directories to search in
   -f, --files                  list of files to search in
   -h, --help                   print help
   -i, --ignore                 list of files, directories, or types to ignore
   -p, --parse-depth            depth to recursively parse directories
   -r, --remote                 list / create tokens for Bitbucket/Github
   -t, --tags                   list of tags to search for
   -v, --version                print watson version and info

Any number of files, tags, dirs, and ignores can be listed after flag
Ignored files should be space separated
To use *.filetype identifier, encapsulate in "" to avoid shell substitutions

Report bugs to: watson@goosecode.com
watson home page: <http://goosecode.com/projects/watson>
[goosecode] labs | 2012-2013

```
### All file/directory/tag related parameters support relative as well as absolute paths.


### -d, --dirs [DIRS]
This parameter specifies which directories watson should parse through.
It should be followed by a space separated list of directories that should be parsed.
If watson is run without this parameter, the current directory is parsed.


### -f, --files [FILES]
This parameter specifies which files watson should parse through.
It should be followed by a space separated list of files that should be parsed.


### -h, --help
This parameter displays the list of avaliable options for watson.


### -i, --ignore [IGNORES]
This parameter specifies which files and directories watson should ignore when parsing.
It should be followed by a space separated list of files and/or directories to be ignored.
This parameter should be used as an opposite to -d/-f, when there are more files that should be parsed in a directory than should be ignored.


### -p, --parse-depth [PARSE_DEPTH]
This parameter specifies how deep watson should recursively parse directories.
The 'depth' is defined as how many levels deep from the top-most specified directory to parse.
If individual directories are passed with the -d (--dirs) flag, each will be parsed PARSE_DEPTH layers, regardless of their depth from the current directory.
If watson is run without this parameter, the parsing depth is unlimited and will search through all subdirectories found.


### -r, --remote [GITHUB, BITBUCKET]
This parameter is used to both list currently established remotes as well as setup new ones.
If passed without any options, the currently established remotes will be listed.
If passed with a github or bitbucket argument, watson will proceed to ask some questions to set up the corresponding remote.


### -t, --tags [TAGS]
This parameter is used to specify which tags watson should look for when parsing.
The tag currently supports any regular character and number combination, no special (!@#$...) characters.


### -v, --version
This parameter displays the current version of watson you are running.


## .watsonrc
watson supports an RC file that allows for reusing commong settings without repeating command line arguments every time.

The .watsonrc is placed in every directory that watson is run from as opposed to a unified file (in ~/.watsonrc for example). The thinking behind this is that each project may have a different set of folders to ignore, directories to search through, and tags to look for.
For example, a C/C++ project might want to look in src/ and ignore obj/ whereas a Ruby project might want to look in lib/ and ignore assets/.

The .watsonrc file is fairly straightforward...
**[dirs]** - This is a newline separated list of directories to look in while parsing.

**[tags]** - This is a newline separated list of tags to look for while parsing.

**[ignore]** - This is a newline separated list of files / folders to ignore while parsing.
This supports wildcard type selecting by providing .filename (no * required)

**[(github/bitbucket)]** - If a remote is established, the API key for the corresponding remote is stored here.
Currently, OAuth has yet to be implemented for Bitbucket so the Bitbucket username is stored here.

**[(github/bitbucket)_repo]** - The repo name / path is stored here.

The remote related .watsonrc options shouldn't need to be edited manually, as they are automatically populated when the -r, --remote setup is called.

## Bugs

Yes, loads of them. Please report any bugs to the fork you are using.

 * Stable: <https://github.com/nhmood/watson-perl/issues>
 * Unstable: <https://github.com/latk/watson-perl/issues>

## Special Thanks
Special thanks to [@samirahmed](http://twitter.com/samirahmed) for his super Ruby help and testing watson-ruby!
Special thanks to [@eugenekolo](http://twitter.com/eugenekolo) [[email](eugenek@bu.edu)] for his super Perl help!
Special thanks to [@crowell](http://github.com/crowell) for helping test out watson-ruby!

## FAQ
- **Why Perl?**
	I wanted to learn Perl and this seemed like a pretty decent project

- **Why is the Perl version different from the Ruby version?**
	The Ruby version was developed after the Perl version was made. Because of this, it was a lot easier to add on features that were thought of while/after making the Perl version as the plumbing was still being setup.
	With a combination of wanting to finish watson-ruby as well as laziness, some of the improvements that were added to watson-ruby *have yet* to be pulled back into watson-perl.
	If you are interested in helping out or maintaining watson-perl let me know!
