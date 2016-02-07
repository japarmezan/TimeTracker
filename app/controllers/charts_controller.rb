class ChartsController < ApplicationController
  before_action :set_chart, only: [:show, :edit, :update, :destroy]

  # GET /charts
  # GET /charts.json
  def index
    projects = current_user.tasks + current_user.projects
    names = projects.map(&:name)
    hours = []
    projects.each do |p|
      h = 0
      p.tracks.each do |t|
        h += (t.end - t.start) / 60 / 60 if t.end
      end
      hours << h
    end
    @chart = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(text: "Hours spent on your pojects")
      f.xAxis(categories: names)
      f.series(name: "Spent hours", yAxis: 0, data: hours)

      f.yAxis [
        {title: {text: "Spent hours", margin: 70} }
      ]

      f.legend(align: 'right', verticalAlign: 'top', y: 75, x: -50, layout: 'vertical')
      f.chart({defaultSeriesType: "column"})
    end
  end
end
