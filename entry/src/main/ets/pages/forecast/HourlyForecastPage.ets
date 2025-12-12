/**
 * 48小时天气预报页面
 */

import { HourlyForecast } from '../../common/WeatherDataModel'
import { getHourlyForecast } from '../../common/WeatherAPI'
import { CityManager } from '../../common/CityManager'
import router from '@ohos.router'

@Entry
@Component
struct HourlyForecastPage {
  @State hourlyForecasts: HourlyForecast[] = []
  @State isLoading: boolean = false
  @State errorMessage: string = ''
  
  private cityManager: CityManager = CityManager.getInstance()
  
  aboutToAppear(): void {
    this.loadHourlyForecast()
  }
  
  // 加载小时预报数据
  async loadHourlyForecast() {
    this.isLoading = true
    this.errorMessage = ''
    
    try {
      // 获取当前城市
      let location = '101010100' // 默认使用北京的城市ID
      const currentCity = this.cityManager.getCurrentCity()
      if (currentCity && currentCity.id) {
        location = currentCity.id
      }
      
      // 获取48小时预报
      const forecasts = await getHourlyForecast(location, 48)
      this.hourlyForecasts = forecasts
    } catch (error) {
      this.errorMessage = (error as Error).message || '获取小时预报失败'
    } finally {
      this.isLoading = false
    }
  }
  
  // 格式化时间显示
  formatTime(timeStr: string): string {
    const date = new Date(timeStr)
    const hours = date.getHours()
    return `${hours}点`
  }
  
  // 获取温度数组用于绘制图表
  getTemperatureArray(): number[] {
    return this.hourlyForecasts.map(forecast => forecast.temperature)
  }
  
  // 获取最大温度
  getMaxTemperature(): number {
    const temps = this.getTemperatureArray()
    return temps.length > 0 ? Math.max(...temps) : 0
  }
  
  // 获取最小温度
  getMinTemperature(): number {
    const temps = this.getTemperatureArray()
    return temps.length > 0 ? Math.min(...temps) : 0
  }
  
  build() {
    Column() {
      // 页面标题
      Row() {
        Text('48小时预报')
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
              this.loadHourlyForecast()
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
        
        // 小时预报列表（垂直）
        Scroll() {
          Column() {
            ForEach(this.hourlyForecasts, (forecast: HourlyForecast, index: number) => {
              Row() {
                // 时间
                Text(this.formatTime(forecast.time))
                  .fontSize(16)
                  .layoutWeight(1)
                
                // 天气状况
                Text(forecast.weatherCondition)
                  .fontSize(16)
                  .layoutWeight(1)
                  .textAlign(TextAlign.Center)
                
                // 温度
                Text(`${forecast.temperature}°C`)
                  .fontSize(16)
                  .fontWeight(FontWeight.Bold)
                  .layoutWeight(1)
                  .textAlign(TextAlign.End)
              }
              .padding({ left: 20, right: 20, top: 10, bottom: 10 })
              .border({ width: 1 })
              .borderRadius(8)
              .margin({ bottom: 5 })
            }, (item: HourlyForecast) => item.time)
          }
          .padding({ left: 10, right: 10, bottom: 20 })
        }
        .layoutWeight(1)
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
function TemperatureChart(page: HourlyForecastPage) {
  Column() {
    // 图表标题
    Text('温度变化趋势')
      .fontSize(18)
      .fontWeight(FontWeight.Bold)
      .margin({ bottom: 10 })
    
    // TODO: 可接入自定义曲线图（Spline）组件，将 page.hourlyForecasts 的温度数组绘制成平滑曲线
    // 这里先留空，避免引入额外依赖影响编译
  }
  .padding({ left: 20, right: 20 })
}