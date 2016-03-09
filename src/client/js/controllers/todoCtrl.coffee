module.exports = ($scope, list, title, todoService)->
  do (title)-> # To get the title uppercase
    arr = title.split ''
    arr[0] = arr[0].toUpperCase()
    $scope.title = arr.join ''
  $scope.list = list
  $scope.submitTodo = (todoObj)->
    todoService
      .addTodo todoObj
      .then ()->
        console.log "Status #{title}"
        todoService
          .getTodos title
          .then (todos)->
            $scope.newTodo = ''
            $scope.list = todos
            $scope.$apply()
