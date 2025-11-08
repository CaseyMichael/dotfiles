;; Relay graphql template literals
(call_expression
  function: (identifier) @_name
  arguments: (template_string) @injection.content
  (#eq? @_name "graphql")
  (#set! injection.language "graphql")
  (#offset! @injection.content 0 1 0 -1))

;; graphql.experimental template literals
(call_expression
  function: (member_expression
    object: (identifier) @_obj
    property: (property_identifier) @_prop)
  arguments: (template_string) @injection.content
  (#eq? @_obj "graphql")
  (#eq? @_prop "experimental")
  (#set! injection.language "graphql")
  (#offset! @injection.content 0 1 0 -1))

;; gql template literals (alternative tag)
(call_expression
  function: (identifier) @_name
  arguments: (template_string) @injection.content
  (#eq? @_name "gql")
  (#set! injection.language "graphql")
  (#offset! @injection.content 0 1 0 -1))
