Feature: Check for more recent versions

  @less-than-php-7
  Scenario: Check for update via Version Check API
    Given a WP install

    When I run `wp core download --version=3.8 --force`
    Then STDOUT should not be empty

    When I run `wp core check-update`
    Then STDOUT should be a table containing rows:
      | version | update_type | package_url                                                  |
      | 4.4.2   | major       | https://downloads.wordpress.org/release/wordpress-4.4.2.zip  |
      | 3.8.13  | minor       | https://downloads.wordpress.org/release/wordpress-3.8.13-partial-0.zip |

    When I run `wp core check-update --format=count`
    Then STDOUT should be:
      """
      2
      """

    When I run `wp core check-update --major`
    Then STDOUT should be a table containing rows:
      | version | update_type | package_url                                                  |
      | 4.4.2   | major       | https://downloads.wordpress.org/release/wordpress-4.4.2.zip  |

    When I run `wp core check-update --major --format=count`
    Then STDOUT should be:
      """
      1
      """

    When I run `wp core check-update --minor`
    Then STDOUT should be a table containing rows:
      | version | update_type | package_url                                |
      | 3.8.13  | minor       | https://downloads.wordpress.org/release/wordpress-3.8.13-partial-0.zip |

    When I run `wp core check-update --minor --format=count`
    Then STDOUT should be:
      """
      1
      """

  @less-than-php-7
  Scenario: No minor updates for an unlocalized WordPress release
    Given a WP install

    When I run `wp core download --version=4.0 --locale=es_ES --force`
    Then STDOUT should contain:
      """
      Success: WordPress downloaded.
      """

    When I run `wp core check-update --minor`
    Then STDOUT should be a table containing rows:
      | version | update_type | package_url                                        |
      | 4.0.10  | minor       | https://downloads.wordpress.org/release/wordpress-4.0.10-partial-0.zip |