(function () {
  'use strict';
  angular.module('confirmClick', []);
  angular.module('confirmClick').directive('confirmClick', [
    '$timeout',
    '$document',
    function ($timeout, $document) {
      return {
        scope: {},
        link: function (scope, element, attrs) {
          var actionText, promise, textWidth;
          actionText = element.text();
          textWidth = null;
          promise = null;
          scope.confirmingAction = false;
          scope.$watch('confirmingAction', function (newVal, oldVal) {
            if (scope.confirmingAction) {
              element.text(attrs.confirmMessage);
              return element.addClass('confirming');
            } else {
              element.text(actionText);
              return element.removeClass('confirming');
            }
          });
          return element.bind('click', function () {
            if (!scope.confirmingAction) {
              scope.$apply(function () {
                return scope.confirmingAction = true;
              });
              return promise = $timeout(function () {
                return scope.confirmingAction = false;
              }, 1500);
            } else {
              $timeout.cancel(promise);
              element.removeClass('confirming');
              element.text(actionText);
              scope.confirmingAction = false;
              return scope.$parent.$apply(attrs.confirmClick);
            }
          });
        }
      };
    }
  ]);
}.call(this));