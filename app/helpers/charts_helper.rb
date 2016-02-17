# Charts helper
module ChartsHelper
  def chart_by_collaborators(project)
    names = project.coworkers.map(&:name) << project.author.name
    hours = []
    names.each do |e|
      h = 0
      tracks = project.tracks_for_user_by_name(e)
      tracks.each do |t|
        h += ((t.end - t.start) / 60 / 60).round(2) if t.end
      end
      hours << h
    end
    chart = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(text: "Hours spent by collaborator")
      f.xAxis(categories: names)
      f.series(name: "Spent hours", yAxis: 0, data: hours)

      f.yAxis [
        { title: { text: "Spent hours", margin: 50 } }
      ]

      f.legend(align: 'right', verticalAlign: 'top', y: 75, x: -30, layout: 'vertical')
      f.chart(defaultSeriesType: "column")
    end
    chart
  end

  def chart_by_labels(project)
    labels = project.labels.map(&:name)
    hours = []
    project.labels.map(&:id).each do |e|
      h = 0
      tracks = project.tracks_for_label(e)
      tracks.each do |t|
        h += ((t.end - t.start) / 60 / 60).round(2) if t.end
      end
      hours << h
    end

    data = labels.zip(hours)

    chart = LazyHighCharts::HighChart.new('pie') do |f|
      f.title(text: "Hours spent by label")
      f.series(name: "Spent hours", yAxis: 0, data: data)

      f.chart(defaultSeriesType: "pie")
    end
    chart
  end

  def chart_by_date(project)
    dates = (7.days.ago.to_date..Date.today).map
    hours = []

    dates.each do |date|
      h = 0
      tracks = project.tracks_by_date(date)
      tracks.each do |t|
        h += ((t.end - t.start) / 60 / 60).round(2) if t.end
      end
      hours << h
    end

    dates = dates.map { |d| d.strftime("%d.%m.") }

    chart = LazyHighCharts::HighChart.new('line') do |f|
      f.title(text: "Hours spent last week")
      f.xAxis(categories: dates)

      f.series(name: "Hours spent", yAxis: 0, data: hours)

      f.yAxis [
        { title: { text: "Hours spent", margin: 50 } }
      ]

      f.chart(defaultSeriesType: "line")
    end
    chart
  end

  def chart_by_date_and_user(project)
    dates = (3.days.ago.to_date..Date.today)
    users = project.contributors
    series = {}

    users.each do |user|
      hours = 0
      dates.each do |date|
        h = 0
        tracks = project.tracks_by_date_and_user(user, date)
        tracks.each do |t|
          h += ((t.end - t.start) / 60 / 60).round(2) if t.end
        end
        hours << h
      end
      series[user.name] = hours
    end

    dates = dates.map { |d| d.strftime("%d.%m.") }
    chart = LazyHighCharts::HighChart.new('line') do |f|
      f.title(text: "Hours spent last month")
      f.xAxis(categories: dates)

      series.each do |user, hours|
        f.series(name: user, yAxis: 0, data: hours)
      end

      f.yAxis [
        { title: { text: "Spent hours", margin: 50 } }
      ]

      f.chart(defaultSeriesType: "line")
    end
    chart
  end
end
