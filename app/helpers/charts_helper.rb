# Charts helper
module ChartsHelper
  def chart_for_project(project)
    emails = project.coworkers.map(&:email) << project.author.email
    hours = []
    emails.each do |e|
      h = 0
      tracks = project.tracks_for_user_by_email(e)
      tracks.each do |t|
        h += (t.end - t.start) / 60 / 60 if t.end
      end
      hours << h
    end
    chart = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(text: "Hours spent on pojects")
      f.xAxis(categories: emails)
      f.series(name: "Spent hours", yAxis: 0, data: hours)

      f.yAxis [
        { title: { text: "Spent hours", margin: 50 } }
      ]

      f.legend(align: 'right', verticalAlign: 'top', y: 75, x: -50, layout: 'vertical')
      f.chart(defaultSeriesType: "column")
    end
    chart
  end
end
