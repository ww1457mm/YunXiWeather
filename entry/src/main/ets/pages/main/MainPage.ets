import { CurrentWeather } from '../../common/WeatherDataModel'
import { getCurrentWeather, getAirQuality, getDailyForecast } from '../../common/WeatherAPI'
import { CityManager } from '../../common/CityManager'
import router from '@ohos.router'

@Entry
@Component
struct MainPage {
  @State currentWeather: CurrentWeather = new CurrentWeather()
  @State isLoading: boolean = false
  @State errorMessage: string = ''
  @State aqi: number = 0
  @State aqiDescription: string = ''
  @State highTemp: number = 0
  @State lowTemp: number = 0
  
  private cityManager: CityManager = CityManager.getInstance()
  
  aboutToAppear(): void {
    // 初始化时获取天气数据
    this.refreshWeather()
  }
  
  // 页面每次显示时都会调用（从其他页面返回时也会触发）
  onPageShow(): void {
    // 从城市页面返回时，刷新天气数据
    this.refreshWeather()
  }
  
  // 刷新天气数据
  async refreshWeather() {
    this.isLoading = true
    this.errorMessage = ''
    
    try {
      // 获取当前城市
      let location = '101300601' // 默认梧州万秀
      let latitude = 23.48
      let longitude = 111.32
      
      const currentCity = this.cityManager.getCurrentCity()
      if (currentCity && currentCity.id) {
        location = currentCity.id
        latitude = currentCity.latitude
        longitude = currentCity.longitude
      }
      
      // 获取实时天气
      const weather = await getCurrentWeather(location)
      // API不返回城市名时回填默认/当前城市名
      weather.cityName = weather.cityName || currentCity?.name || '万秀'
      this.currentWeather = weather

      // 获取当日最高/最低气温
      try {
        const daily = await getDailyForecast(location, 1)
        if (daily && daily.length > 0) {
          this.highTemp = daily[0].maxTemperature
          this.lowTemp = daily[0].minTemperature
        }
      } catch (e) {
        console.warn('Get daily forecast failed', (e as Error).message)
      }
      
      // 获取空气质量（使用经纬度）
      const airQuality = await getAirQuality(latitude, longitude)
      this.aqi = airQuality.aqi
      this.aqiDescription = airQuality.quality
    } catch (error) {
      const errorMsg = (error as Error).message || '获取天气数据失败'
      // 判断是否是403权限错误
      if (errorMsg.includes('403')) {
        this.errorMessage = 'API权限不足，请在和风天气控制台开通天气数据服务'
      } else {
        this.errorMessage = errorMsg
      }
    } finally {
      this.isLoading = false
    }
  }
  
  // 跳转到城市选择页面
  goToCityPage() {
    router.pushUrl({ url: 'pages/city/CityPage' }).catch((err: Error) => {
      console.error('Navigation failed:', err.message)
    })
  }
  
  // 跳转到48小时预报页面
  goToHourlyForecast() {
    router.pushUrl({ url: 'pages/forecast/HourlyForecastPage' }).catch((err: Error) => {
      console.error('Navigation failed:', err.message)
    })
  }
  
  // 跳转到7天预报页面
  goToDailyForecast() {
    router.pushUrl({ url: 'pages/forecast/DailyForecastPage' }).catch((err: Error) => {
      console.error('Navigation failed:', err.message)
    })
  }
  
  // 跳转到空气质量页面
  goToAirQuality() {
    router.pushUrl({ url: 'pages/air/AirQualityPage' }).catch((err: Error) => {
      console.error('Navigation failed:', err.message)
    })
  }
  
  // 跳转到生活建议页面
  goToLifeAdvice() {
    router.pushUrl({ url: 'pages/life/LifeAdvicePage' }).catch((err: Error) => {
      console.error('Navigation failed:', err.message)
    })
  }
  
  // 跳转到预警页面
  goToWarnings() {
    router.pushUrl({ url: 'pages/warning/WarningPage' }).catch((err: Error) => {
      console.error('Navigation failed:', err.message)
    })
  }
  
  build() {
    Stack() {
      Image($r('app.media.gradient_bg'))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Fill)
      
      Column() {
      // 顶部导航栏
      Row()
         {
          // 中间空白，用于保持居中布局
          Blank().layoutWeight(1)
          
          // 右侧：切换按钮（下移一点）
          Button('切换')
            .onClick(() => {
              this.goToCityPage()
            })
            .height(34)
            .backgroundColor('rgba(255,255,255,0.18)')
            .backdropBlur(20)
            .border({ width: 1, color: 'rgba(255,255,255,0.25)' })
            .fontColor(Color.White)
            .fontSize(14)
            .borderRadius(16)
            .width(72)
            .margin({ top: 28 })
            .padding({ left: 8, right: 8 })
        }
      .alignItems(VerticalAlign.Center)
      .padding({ left: 20, right: 60, top: 144, bottom: 12 })
      
      // 加载中提示
      if (this.isLoading) {
        Column() {
          Text('加载中...')
            .fontSize(16)
            .fontColor(Color.White)
        }
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
      } 
      // 错误提示
      else if (this.errorMessage) {
        Column() {
          Text(this.errorMessage)
            .fontColor('#FFD1D1')
            .fontSize(16)
            .textAlign(TextAlign.Center)
          
          Button('重试')
            .onClick(() => {
              this.refreshWeather()
            })
            .margin({ top: 20 })
            .backgroundColor('rgba(255,255,255,0.18)')
            .fontColor(Color.White)
            .borderRadius(8)
        }
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
        .padding(20)
      } 
      // 天气信息展示
      else {
        Column() {
          // 城市名称
          Text(this.cityManager.getCurrentCity()?.name || this.currentWeather.cityName || '梧州')
            .fontSize(36)
            .fontWeight(FontWeight.Bold)
            .fontColor(Color.White)
            .letterSpacing(2)
            .textAlign(TextAlign.Center)
            .margin({ bottom: 6 })
          
          // 天气状况
          Text(this.currentWeather.weatherCondition || '暂无数据')
            .fontSize(18)
            .fontColor(Color.White)
            .textAlign(TextAlign.Center)
            .margin({ bottom: 12 })
          
          // 图标 + 温度（超大字号）
          Text(`${this.currentWeather.temperature}°C`)
            .fontSize(80)
            .fontWeight(FontWeight.Lighter)
            .fontColor(Color.White)
            .textAlign(TextAlign.Center)
            .margin({ bottom: 12 })
          
          // 体感与 AQI 芯片
          Row() {
            this.buildChip(`体感 ${this.currentWeather.feelsLike}°C`)
            Blank().width(8)
            this.buildChip(`AQI ${this.aqi} ${this.aqiDescription}`, this.getAQIColor(this.aqi))
          }
          .justifyContent(FlexAlign.Center)
          .margin({ bottom: 14 })
          
          // 当日最高/最低温度
          Text(`今日 最高 ${this.formatTemp(this.highTemp)} / 最低 ${this.formatTemp(this.lowTemp)}`)
            .fontSize(14)
            .fontColor('#E8F3FF')
            .textAlign(TextAlign.Center)
            .margin({ bottom: 16 })
          
          // 其他天气信息
          Column() {
            Row() {
              this.buildMetricCard('湿度', `${this.currentWeather.humidity}%`, '💧')
              this.buildMetricCard('风速', `${this.currentWeather.windSpeed} km/h`, '🌬️')
            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)
            .margin({ bottom: 10 })
            
            Row() {
              this.buildMetricCard('气压', `${this.currentWeather.pressure} hPa`, '🧭')
              this.buildMetricCard('能见度', `${this.currentWeather.visibility} km`, '👁️')
            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)
          }
          .width('90%')
        }
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
        .padding({ left: 20, right: 20 })
      }
      
      // 功能导航按钮区域
      if (!this.isLoading && !this.errorMessage) {
        Column() {
          // 第一行按钮
          Row() {
            Button('48小时预报')
              .onClick(() => {
                this.goToHourlyForecast()
              })
              .layoutWeight(1)
              .height(40)
              .backgroundColor('rgba(255,255,255,0.2)')
              .backdropBlur(20)
              .border({ width: 1, color: 'rgba(255,255,255,0.3)' })
              .fontColor(Color.White)
              .borderRadius(24)
              .margin({ right: 5 })
            
            Button('7天预报')
              .onClick(() => {
                this.goToDailyForecast()
              })
              .layoutWeight(1)
              .height(40)
              .backgroundColor('rgba(255,255,255,0.2)')
              .backdropBlur(20)
              .border({ width: 1, color: 'rgba(255,255,255,0.3)' })
              .fontColor(Color.White)
              .borderRadius(24)
              .margin({ left: 5 })
          }
          .width('90%')
          .margin({ bottom: 10 })
          
          // 第二行按钮
          Row() {
            Button('空气质量')
              .onClick(() => {
                this.goToAirQuality()
              })
              .layoutWeight(1)
              .height(40)
              .backgroundColor('rgba(255,255,255,0.2)')
              .backdropBlur(20)
              .border({ width: 1, color: 'rgba(255,255,255,0.3)' })
              .fontColor(Color.White)
              .borderRadius(24)
              .margin({ right: 5 })
            
            Button('生活建议')
              .onClick(() => {
                this.goToLifeAdvice()
              })
              .layoutWeight(1)
              .height(40)
              .backgroundColor('rgba(255,255,255,0.2)')
              .backdropBlur(20)
              .border({ width: 1, color: 'rgba(255,255,255,0.3)' })
              .fontColor(Color.White)
              .borderRadius(24)
              .margin({ left: 5 })
          }
          .width('90%')
          .margin({ bottom: 10 })
          
          // 预警按钮
          Row() {
            Button('极端天气预警')
              .onClick(() => {
                this.goToWarnings()
              })
              .width('90%')
              .height(40)
              .backgroundColor('rgba(255,255,255,0.2)')
              .backdropBlur(20)
              .border({ width: 1, color: 'rgba(255,255,255,0.3)' })
              .fontColor(Color.White)
              .borderRadius(24)
          }
          .width('100%')
          .justifyContent(FlexAlign.Center)
        }
        .margin({ bottom: 20 })
      }
      
      // 底部刷新按钮
      Row() {
        Button('刷新天气')
          .onClick(() => {
            this.refreshWeather()
          })
          .width('90%')
          .height(40)
          .backgroundColor('rgba(255,255,255,0.2)')
          .backdropBlur(20)
          .border({ width: 1, color: 'rgba(255,255,255,0.3)' })
          .fontColor(Color.White)
          .borderRadius(24)
      }
      .justifyContent(FlexAlign.Center)
      .margin({ top: 10, bottom: 20 })
      }
      .width('100%')
      .height('100%')
    }
    .width('100%')
    .height('100%')
  }
  
  // 根据AQI值返回对应颜色
  getAQIColor(aqi: number): ResourceColor {
    if (aqi <= 50) {
      return '#1E8E3E' // 深绿
    } else if (aqi <= 100) {
      return '#B8860B' // 金黄，较深
    } else if (aqi <= 150) {
      return '#FF8C00' // 深橙
    } else if (aqi <= 200) {
      return '#D93025' // 深红
    } else if (aqi <= 300) {
      return '#7E57C2' // 深紫
    } else {
      return '#6D4C41' // 深褐
    }
  }

  // 温度显示格式化
  formatTemp(temp: number): string {
    if (temp === undefined || temp === null) {
      return '--°C'
    }
    return `${temp}°C`
  }

  // 气象要素卡片
  @Builder
  buildMetricCard(label: string, value: string, icon: string) {
    Column() {
      Row() {
        Text(icon)
          .fontSize(16)
          .fontColor('#E8F3FF')
          .margin({ right: 6 })
        Text(label)
          .fontSize(14)
          .fontColor('#E8F3FF')
      }
      .margin({ bottom: 8 })
      Text(value)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontColor(Color.White)
    }
    .padding({ top: 18, bottom: 18, left: 20, right: 20 })
    .backgroundColor('rgba(255,255,255,0.20)')
    .backdropBlur(20)
    .border({ width: 1, color: 'rgba(255,255,255,0.3)' })
    .borderRadius(24)
    .shadow({ radius: 12, color: 'rgba(0,0,0,0.12)', offsetX: 0, offsetY: 6 })
    .width('48%')
  }

  // 芯片样式（体感/AQI）
  @Builder
  buildChip(text: string, color?: ResourceColor) {
    Text(text)
      .fontSize(14)
      .fontColor(color || '#E8F3FF')
      .padding({ left: 14, right: 14, top: 6, bottom: 6 })
      .backgroundColor('rgba(255,255,255,0.20)')
      .borderRadius(18)
      .shadow({ radius: 8, color: 'rgba(0,0,0,0.12)', offsetX: 0, offsetY: 4 })
  }

  // 根据天气/昼夜返回背景色（用于不支持渐变的环境）
  getBackgroundColor(): string {
    const cond = (this.currentWeather.weatherCondition || '').toLowerCase()
    const hour = this.getCurrentHour()
    const isNight = hour >= 19 || hour < 6
    if (isNight) {
      return '#0A2342' // 深蓝夜间
    }
    if (cond.includes('雨') || cond.includes('rain') || cond.includes('雷')) {
      return '#5A6478' // 灰蓝雨天
    }
    if (cond.includes('雪') || cond.includes('snow')) {
      return '#6B7A8F' // 冬日灰蓝
    }
    if (cond.includes('阴') || cond.includes('云') || cond.includes('cloud')) {
      return '#3E5C76' // 多云
    }
    return '#4FACFE' // 晴天默认
  }

  getCurrentHour(): number {
    // 优先解析接口更新时间，否则取本地时间
    const t = this.currentWeather.updateTime
    if (t) {
      const d = new Date(t)
      if (!isNaN(d.getTime())) {
        return d.getHours()
      }
    }
    return new Date().getHours()
  }
}