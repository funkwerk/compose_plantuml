Feature: Boundaries
  As a DevOps,
  I want to see the boundaries of a system
  so that I know how to interact with it.

  Scenario Outline: Exposed ports
    Given a file named "compose.yml" with:
      """
      version: "2"
      services:
        service:
          ports:
            - <port>
      """
    When I run `bin/compose_plantuml --boundaries compose.yml`
    Then it should pass with exactly:
      """
      skinparam componentStyle uml2
      cloud system {
        [service]
      }
      [service] --> <resulting port>

      """

    Examples: TCP Port
      | port | resulting port |
      | 8080 | 8080           |

    Examples: UDP Port
      | port     | resulting port |
      | 8080/udp | 8080udp        |

    Examples: Alias Port
      | port    | resulting port |
      | 8080:80 | 8080 : 80      |

    Examples: Alias Port
      | port      | resulting port |
      | 8000-8099 | 8000..8099     |

  Scenario: Exposed complex port
    Given a file named "compose.yml" with:
      """
      version: "2"
      services:
        service:
          ports:
            - published: 1
              target: 2
      """
    When I run `bin/compose_plantuml --boundaries compose.yml`
    Then it should pass with exactly:
      """
      skinparam componentStyle uml2
      cloud system {
        [service]
      }
      [service] --> 1 : 2

      """

  Scenario: Volumes
    Given a file named "compose.yml" with:
      """
      version: "2"
      services:
        service:
          volumes:
            - service_log:/log
      volumes:
        service_log: {}
      """
    When I run `bin/compose_plantuml --boundaries compose.yml`
    Then it should pass with exactly:
      """
      skinparam componentStyle uml2
      cloud system {
        [service]
      }
      database service_log {
        [/log] as volume_1
      }
      [service] --> volume_1

      """

  Scenario: Volumes with complex syntax
    Given a file named "compose.yml" with:
      """
      version: "2"
      services:
        service:
          volumes:
            - type: bind
            - source: service_log
            - target: /log
      volumes:
        service_log: {}
      """
    When I run `bin/compose_plantuml --boundaries compose.yml`
    Then it should pass with exactly:
      """
      skinparam componentStyle uml2
      cloud system {
        [service]
      }
      database service_log {
        [/log] as volume_1
      }
      [service] --> volume_1

      """

  Scenario: Filter internal services
    Given a file named "compose.yml" with:
      """
      version: "2"
      services:
        service:
          volumes:
            - service_log:/log
        unused_service: {}
      volumes:
        service_log: {}
        unused_volume: {}
      """
    When I run `bin/compose_plantuml --boundaries compose.yml`
    Then it should pass with exactly:
      """
      skinparam componentStyle uml2
      cloud system {
        [service]
      }
      database service_log {
        [/log] as volume_1
      }
      [service] --> volume_1

      """

  Scenario Outline: Group Volumes and Ports
    Given a file named "compose.yml" with:
      """
      version: "2"
      services:
        service:
          volumes:
            - service_log:/log
          ports:
           - <port>:80
        unused_service: {}
      volumes:
        service_log: {}
        unused_volume: {}
      """
    When I run `bin/compose_plantuml --boundaries --group compose.yml`
    Then it should pass with exactly:
      """
      skinparam componentStyle uml2
      cloud system {
        [service]
      }
      package volumes {
        database service_log {
          [/log] as volume_1
        }
      }
      package ports {
        interface <resulting port>
      }
      [service] --> <resulting port> : 80
      [service] --> volume_1

      """

    Examples: TCP Pport
      | port | resulting port |
      | 8080 | 8080           |

    Examples: UDP Pport
      | port     | resulting port |
      | 8080/udp | 8080udp        |

  Scenario: Notes
    Given a file named "compose.yml" with:
      """
      version: "2"
      services:
        service:
          volumes:
            - service_log:/log
          labels:
            key:value
      volumes:
        service_log: {}
      """
    When I run `bin/compose_plantuml --boundaries --notes compose.yml`
    Then it should pass with exactly:
      """
      skinparam componentStyle uml2
      cloud system {
        [service]
        note top of [service]
          key=value
        end note
      }
      database service_log {
        [/log] as volume_1
      }
      [service] --> volume_1
      """

  Scenario: Ports only
    Given a file named "compose.yml" with:
      """
      version: "2"
      services:
        service:
          volumes:
            - service_log:/log
          ports:
           - 8080
      volumes:
        service_log: {}
      """
    When I run `bin/compose_plantuml --port_boundaries compose.yml`
    Then it should pass with exactly:
      """
      skinparam componentStyle uml2
      cloud system {
        [service]
      }
      [service] --> 8080

      """

  Scenario: Volumes only
    Given a file named "compose.yml" with:
      """
      version: "2"
      services:
        service:
          volumes:
            - service_log:/log
          ports:
           - 8080
      volumes:
        service_log: {}
      """
    When I run `bin/compose_plantuml --volume_boundaries compose.yml`
    Then it should pass with exactly:
      """
      skinparam componentStyle uml2
      cloud system {
        [service]
      }
      database service_log {
        [/log] as volume_1
      }
      [service] --> volume_1

      """

  Scenario: Suppport for legacy docker-compose format
    Given a file named "compose.yml" with:
      """
      service:
        ports:
          - 8080:80
      """
    When I run `bin/compose_plantuml --boundaries compose.yml`
    Then it should pass with exactly:
      """
      skinparam componentStyle uml2
      cloud system {
        [service]
      }
      [service] --> 8080 : 80

      """
