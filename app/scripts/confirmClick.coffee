'use strict'

angular.module 'confirmClick', []

angular.module('confirmClick')
  .directive 'confirmClick', ($timeout, $document) ->
    scope: {}
    link: (scope, element, attrs) ->
      # Original text
      actionText = element.text()

      # Original Width
      textWidth = null

      # Timeout
      promise = null

      # Default to a false position
      scope.confirmingAction = false

      # Toggle text based on current state
      scope.$watch 'confirmingAction', (newVal, oldVal) ->

        if scope.confirmingAction
          # Show confirm message
          element.text attrs.confirmMessage

          # Acknowledge in confirming state
          element.addClass 'confirming'
        else
          # Show original message
          element.text actionText

          # Acknowledge not in confirming state anymore
          element.removeClass 'confirming'

      # handle click on button
      element.bind 'click', ->
        # First Click
        if !scope.confirmingAction
          # Show confirm action
          scope.$apply ->
            scope.confirmingAction = true

          # Revert if the user does not confirm
          promise = $timeout ->
            scope.confirmingAction = false
          , 1500

        # Subsequent clicks
        else

          # Ensure the confirm action text remains
          $timeout.cancel promise

          # Acknowledge not in confirming state anymore
          element.removeClass 'confirming'

          # Show original message
          element.text actionText

          # Allow button to be clicked multiply times
          scope.confirmingAction = false

          # Trigger action
          scope.$parent.$apply attrs.confirmClick
