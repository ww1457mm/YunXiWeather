/**
 * 7天天气预报页面
 */

import { DailyForecast } from '../../common/WeatherDataModel'
import { getDailyForecast } from '../../common/WeatherAPI'
import { CityManager } from '../../common/CityManager'
import router from '@ohos.router'

@Entry
@Component
struct DailyForecastPage {
  @State dailyForecasts: DailyForecast[] = []
  @State isLoading: boolean = false
  @State errorMessage: string = ''
  
  private cityManager: CityManager = CityManager.getInstance()
  
  aboutToAppear(): void {
    this.loadDailyForecast()
  }
  
  // 加载日预报数据
  async loadDailyForecast() {
    this.isLoading = true
    this.errorMessage = ''
    
    try {
      // 获取当前城市
      let location = '101010100' // 默认使用北京的城市ID
      const currentCity = this.cityManager.getCurrentCity()
      if (currentCity && currentCity.id) {
        location = currentCity.id
      }
      
      // 获取7天预报
      const forecasts = await getDailyForecast(location, 7)
      this.dailyForecasts = forecasts
    } catch (error) {
      this.errorMessage = (error as Error).message || '获取日预报失败'
    } finally {
      this.isLoading = false
    }
  }
  
  // 格式化日期显示
  formatDate(dateStr: string): string {
    const today = new Date()
    const date = new Date(dateStr)
    
    // 如果是今天
    if (date.toDateString() === today.toDateString()) {
      return '今天'
    }
    
    // 如果是明天
    const tomorrow = new Date(today)
    tomorrow.setDate(tomorrow.getDate() + 1)
    if (date.toDateString() === tomorrow.toDateString()) {
      return '明天'
    }
    
    // 其他日期显示月/日
    return `${date.getMonth() + 1}/${date.getDate()}`
  }
  
  // 获取星期几
  getWeekDay(dateStr: string): string {
    const date = new Date(dateStr)
    const weekdays = ['周日', '周一', '周二', '周三', '周四', '周五', '周六']
    return weekdays[date.getDay()]
  }
  
  build() {
    Column() {
      // 页面标题
      Row() {
        Text('7天预报')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .margin({ top: 20, bottom: 20 })
      }
      .padding({ left: 20, right: 20 })
      
      // 加载中提示
      if (this.isLoading) {
        Column() {
          Text('加载中...')
            .fontSize(16)
        }
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
      } 
      // 错误提示
      else if (this.errorMessage) {
        Column() {
          Text(this.errorMessage)
            .fontColor(Color.Red)
            .fontSize(16)
            .textAlign(TextAlign.Center)
          
          Button('重试')
            .onClick(() => {
              this.loadDailyForecast()
            })
            .margin({ top: 20 })
            .backgroundColor('#007DFF')
            .fontColor(Color.White)
            .borderRadius(8)
        }
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
        .padding(20)
      } 
      // 预报数据展示
      else {
        // 温度趋势图
        TemperatureChart(this)
        
        // 日预报列表
        Column() {
          ForEach(this.dailyForecasts, (forecast: DailyForecast, index: number) => {
            Row() {
              // 日期和星期
              Column() {
                Text(this.formatDate(forecast.date))
                  .fontSize(16)
                  .fontWeight(FontWeight.Bold)
                Text(this.getWeekDay(forecast.date))
                  .fontSize(14)
                  .fontColor('#666666')
              }
              .layoutWeight(1)
              .alignItems(HorizontalAlign.Start)
              
              // 天气状况
              Text(forecast.weatherCondition)
                .fontSize(16)
                .layoutWeight(1)
                .textAlign(TextAlign.Center)
              
              // 温度范围
              Text(`${forecast.maxTemperature}°/${forecast.minTemperature}°`)
                .fontSize(16)
                .fontWeight(FontWeight.Bold)
                .layoutWeight(1)
                .textAlign(TextAlign.End)
            }
            .padding({ left: 20, right: 20, top: 15, bottom: 15 })
            .border({ width: 1 })
            .borderRadius(8)
            .margin({ bottom: 5 })
          }, (item: DailyForecast) => item.date)
        }
        .layoutWeight(1)
        .padding({ left: 10, right: 10, bottom: 20 })
      }
      
      // 返回按钮
      Row() {
        Button('返回')
          .onClick(() => {
            router.back()
          })
          .width('90%')
          .height(40)
          .backgroundColor('#007DFF')
          .fontColor(Color.White)
          .borderRadius(8)
      }
      .justifyContent(FlexAlign.Center)
      .margin({ top: 20, bottom: 20 })
    }
    .width('100%')
    .height('100%')
  }
}

// 温度趋势图组件
@Builder
function TemperatureChart(page: DailyForecastPage) {
  Column() {
    // 图表标题
    Text('温度变化趋势')
      .fontSize(18)
      .fontWeight(FontWeight.Bold)
      .margin({ bottom: 10 })
  }
  .padding({ left: 20, right: 20 })
}