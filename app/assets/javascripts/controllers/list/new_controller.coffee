Skite.ListNewController = Ember.Controller.extend
  needs: 'list'

  isValid: (->
    achievement = @get('content')
    if achievement
      achievement.get('isValid')
    else
      true
  ).property('content.isValid')

  content: null
  input: ""

  errors: (->
    msg = ""
    errors = @get('content.errors')
    msg += errors.title.join(' ') if errors.title
    msg += errors.achievedAt.join(' ') if errors.achievedAt
    msg
  ).property('isValid')

  addAchievement: ->
    achievement = @get('content')

    if achievement
      achievement.set('input', @get('input'))
    else
      achievement = Skite.Achievement.createRecord
        input: @get('input')
        list: @get('controllers.list.content')
      @get('store').transaction().add(achievement)

    achievement.on 'didCreate', @, @resetProperties

    achievement.save()
    @set('content', achievement)

  resetProperties: ->
    @set('content', null)
    @set('input', '')