# AgentStatusBulb

Control a SwitchBot Color Bulb based on agent status.  
Provides simple commands (`asb run`, `asb wait`, `asb idle`, `asb off`) to visualize the state of any agent or task through color changes.

## Installation

Install the gem:

```bash
gem install agent_status_bulb
```

## Usage

Configure your SwitchBot credentials and bulb device:

```bash
asb configure
# Token: (hidden input)
# Secret: (hidden input)
# Device ID: (visible input)
```

Then control the bulb:

```bash
asb run   # blue
asb wait  # orange
asb idle  # green
asb off   # turn off
```

Config file is stored at `~/.config/agent_status_bulb.yml`.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ytkg/agent_status_bulb. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/ytkg/agent_status_bulb/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the AgentStatusBulb project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/ytkg/agent_status_bulb/blob/main/CODE_OF_CONDUCT.md).
