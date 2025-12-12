/**
 * 空气质量监测页面
 */

import { AirQuality } from '../../common/WeatherDataModel'
import { getAirQuality } from '../../common/WeatherAPI'
import { CityManager } from '../../common/CityManager'
import router from '@ohos.router'

@Entry
@Component
struct AirQualityPage {
  @State airQuality: AirQuality = new AirQuality()
  @State isLoading: boolean = false
  @State errorMessage: string = ''
  
  private cityManager: CityManager = CityManager.getInstance()
  
  aboutToAppear(): void {
    this.loadAirQuality()
  }
  
  // 加载空气质量数据
  async loadAirQuality() {
    this.isLoading = true
    this.errorMessage = ''
    
    try {
      // 获取当前城市
      let latitude = 39.90 // 北京纬度
      let longitude = 116.41 // 北京经度
      
      const currentCity = this.cityManager.getCurrentCity()
      if (currentCity && currentCity.id) {
        latitude = currentCity.latitude
        longitude = currentCity.longitude
      }
      
      // 获取空气质量（使用经纬度）
      const airQuality = await getAirQuality(latitude, longitude)
      this.airQuality = airQuality
    } catch (error) {
      this.errorMessage = (error as Error).message || '获取空气质量失败'
    } finally {
      this.isLoading = false
    }
  }
  
  // 获取AQI等级描述
  getAQILevelDescription(level: number): string {
    switch (level) {
      case 1: return '优'
      case 2: return '良'
      case 3: return '轻度污染'
      case 4: return '中度污染'
      case 5: return '重度污染'
      case 6: return '严重污染'
      default: return '未知'
    }
  }
  
  // 获取AQI建议
  getAQIAdvice(level: number): string {
    switch (level) {
      case 1: return '空气质量令人满意，基本无空气污染'
      case 2: return '空气质量可接受，但某些污染物可能对极少数异常敏感人群健康有较弱影响'
      case 3: return '易感人群症状有轻度加剧，健康人群出现刺激症状'
      case 4: return '进一步加剧易感人群症状，可能对健康人群心脏、呼吸系统有影响'
      case 5: return '心脏病和肺病患者症状显著加剧，运动耐受力降低，健康人群普遍出现症状'
      case 6: return '健康人群运动耐受力降低，有明显强烈症状，提前出现某些疾病'
      default: return '暂无建议'
    }
  }
  
  // 获取AQI颜色
  getAQIColor(level: number): ResourceColor {
    switch (level) {
      case 1: return '#1E8E3E' // 深绿
      case 2: return '#B8860B' // 深金黄
      case 3: return '#FF8C00' // 深橙
      case 4: return '#D93025' // 深红
      case 5: return '#7E57C2' // 深紫
      case 6: return '#6D4C41' // 深褐
      default: return Color.Gray
    }
  }
  
  build() {
    Column() {
      // 页面标题
      Row() {
        Text('空气质量')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)
          .margin({ top: 20, bottom: 20 })
      }
      .padding({ left: 20, right: 20 })
      
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
              this.loadAirQuality()
            })
            .margin({ top: 20 })
            .backgroundColor('rgba(255,255,255,0.18)')
            .fontColor(Color.White)
            .borderRadius(10)
        }
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
        .padding(20)
      } 
      // 空气质量数据展示
      else {
        // AQI总体信息
        Column() {
          Text(`AQI ${this.airQuality.aqi}`)
            .fontSize(48)
            .fontWeight(FontWeight.Bold)
            .fontColor(this.getAQIColor(this.airQuality.level))
          
          Text(this.getAQILevelDescription(this.airQuality.level))
            .fontSize(24)
            .fontColor(Color.White)
            .margin({ bottom: 10 })
          
          Text(this.getAQIAdvice(this.airQuality.level))
            .fontSize(16)
            .fontColor('#E8F3FF')
            .textAlign(TextAlign.Center)
            .padding({ left: 20, right: 20 })
        }
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 30 })
        
        // 各项污染物指标
        Column() {
          // PM2.5
          PollutantItem(this, 'PM2.5', this.airQuality.pm25, 50)
          
          // PM10
          PollutantItem(this, 'PM10', this.airQuality.pm10, 100)
          
          // SO2
          PollutantItem(this, 'SO₂', this.airQuality.so2, 150)
          
          // NO2
          PollutantItem(this, 'NO₂', this.airQuality.no2, 100)
          
          // O3
          PollutantItem(this, 'O₃', this.airQuality.o3, 160)
          
          // CO
          PollutantItem(this, 'CO', this.airQuality.co, 5)
        }
        .layoutWeight(1)
        .padding({ left: 20, right: 20 })
      }
      
      // 返回按钮
      Row() {
        Button('返回')
          .onClick(() => {
            router.back()
          })
          .width('90%')
          .height(40)
          .backgroundColor('rgba(255,255,255,0.25)')
          .fontColor(Color.White)
          .borderRadius(10)
      }
      .justifyContent(FlexAlign.Center)
      .margin({ top: 20, bottom: 20 })
    }
    .width('100%')
    .height('100%')
    // 低版本不支持backgroundImage线性渐变，先用单色背景保障编译
    .backgroundColor('#4FACFE')
  }
  
  // 根据污染程度返回颜色
  getPollutantColor(ratio: number): ResourceColor {
    if (ratio <= 0.3) {
      return '#1E8E3E' // 深绿
    } else if (ratio <= 0.6) {
      return '#B8860B' // 深金黄
    } else if (ratio <= 0.8) {
      return '#FF8C00' // 深橙
    } else {
      return '#D93025' // 深红
    }
  }
}

// 污染物指标组件
@Builder
function PollutantItem(page: AirQualityPage, name: string, value: number, maxValue: number) {
  Column() {
    Row() {
      Text(name)
        .fontSize(16)
        .fontColor(Color.White)
        .layoutWeight(1)
      
      Text(`${value}`)
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .fontColor(Color.White)
    }
    .margin({ bottom: 5 })
    
    // 进度条
    Row() {
      Progress({ value: Math.min(value / maxValue * 100, 100), type: ProgressType.Linear })
        .layoutWeight(1)
        .height(10)
        .color(page.getPollutantColor(value / maxValue))
      
      Text(`${Math.round((value / maxValue) * 100)}%`)
        .fontSize(14)
        .fontColor(Color.White)
        .margin({ left: 10 })
    }
  }
  .padding({ top: 12, bottom: 12, left: 16, right: 16 })
  .backgroundColor('rgba(255,255,255,0.20)')
  .borderRadius(20)
  .shadow({ radius: 12, color: 'rgba(0,0,0,0.15)', offsetX: 0, offsetY: 6 })
  .margin({ bottom: 10 })
}