/**
 * 极端天气预警页面
 */

import { ExtremeWeatherWarning } from '../../common/WeatherDataModel'
import { getExtremeWeatherWarnings } from '../../common/WeatherAPI'
import { CityManager } from '../../common/CityManager'
import router from '@ohos.router'

@Entry
@Component
struct WarningPage {
  @State warnings: ExtremeWeatherWarning[] = []
  @State isLoading: boolean = false
  @State errorMessage: string = ''
  
  private cityManager: CityManager = CityManager.getInstance()
  
  aboutToAppear(): void {
    this.loadWarnings()
  }
  
  // 加载极端天气预警数据
  async loadWarnings() {
    this.isLoading = true
    this.errorMessage = ''
    
    try {
      // 获取当前城市
      let location = '101010100' // 默认使用北京的城市ID
      const currentCity = this.cityManager.getCurrentCity()
      if (currentCity && currentCity.id) {
        location = currentCity.id
      }
      
      // 获取极端天气预警
      const warnings = await getExtremeWeatherWarnings(location)
      this.warnings = warnings
    } catch (error) {
      this.errorMessage = (error as Error).message || '获取预警信息失败'
    } finally {
      this.isLoading = false
    }
  }
  
  // 获取预警等级颜色
  getWarningLevelColor(level: string): ResourceColor {
    if (level.includes('蓝色') || level.includes('Blue')) {
      return Color.Blue
    } else if (level.includes('黄色') || level.includes('Yellow')) {
      return Color.Yellow
    } else if (level.includes('橙色') || level.includes('Orange')) {
      return Color.Orange
    } else if (level.includes('红色') || level.includes('Red')) {
      return Color.Red
    } else {
      return Color.Gray
    }
  }
  
  // 格式化发布时间
  formatPubTime(pubTime: string): string {
    const date = new Date(pubTime)
    return `${date.getFullYear()}-${date.getMonth() + 1}-${date.getDate()} ${date.getHours()}:${date.getMinutes().toString().padStart(2, '0')}`
  }
  
  build() {
    Column() {
      // 页面标题
      Row() {
        Text('极端天气预警')
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
              this.loadWarnings()
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
      // 无预警信息
      else if (this.warnings.length === 0) {
        Column() {
          Text('当前无极端天气预警')
            .fontSize(18)
        }
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
      }
      // 预警信息展示
      else {
        Scroll() {
          Column() {
            ForEach(this.warnings, (warning: ExtremeWeatherWarning, index: number) => {
              Column() {
                // 预警标题
                Row() {
                  Text(warning.title)
                    .fontSize(18)
                    .fontWeight(FontWeight.Bold)
                    .layoutWeight(1)
                  
                  Text(warning.level)
                    .fontSize(16)
                    .fontColor(this.getWarningLevelColor(warning.level))
                }
                .margin({ bottom: 10 })
                
                // 发布信息
                Row() {
                  Text(`${warning.sender} 发布`)
                    .fontSize(14)
                    .fontColor('#666666')
                    .layoutWeight(1)
                  
                  Text(this.formatPubTime(warning.pubTime))
                    .fontSize(14)
                    .fontColor('#666666')
                }
                .margin({ bottom: 10 })
                
                // 预警详情
                Text(warning.description)
                  .fontSize(16)
                  .textAlign(TextAlign.Start)
                
                // 有效期
                if (warning.startTime && warning.endTime) {
                  Text(`有效期：${this.formatPubTime(warning.startTime)} 至 ${this.formatPubTime(warning.endTime)}`)
                    .fontSize(14)
                    .fontColor('#666666')
                    .margin({ top: 10 })
                }
              }
              .padding({ left: 20, right: 20, top: 15, bottom: 15 })
              .border({ width: 1 })
              .borderRadius(8)
              .margin({ bottom: 15 })
            }, (item: ExtremeWeatherWarning) => item.id)
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