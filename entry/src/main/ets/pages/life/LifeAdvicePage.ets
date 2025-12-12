/**
 * 健康生活建议页面
 */

import { LifeIndex, LifeIndexItem } from '../../common/WeatherDataModel'
import { getLifeIndex } from '../../common/WeatherAPI'
import { CityManager } from '../../common/CityManager'
import router from '@ohos.router'

@Entry
@Component
struct LifeAdvicePage {
  @State lifeIndex: LifeIndex = new LifeIndex()
  @State isLoading: boolean = false
  @State errorMessage: string = ''
  
  private cityManager: CityManager = CityManager.getInstance()
  
  aboutToAppear(): void {
    this.loadLifeIndex()
  }
  
  // 加载生活指数数据
  async loadLifeIndex() {
    this.isLoading = true
    this.errorMessage = ''
    
    try {
      // 获取当前城市
      let location = '101300601' // 默认使用万秀
      const currentCity = this.cityManager.getCurrentCity()
      if (currentCity && currentCity.id) {
        location = currentCity.id
      }
      
      // 获取生活指数
      const lifeIndex = await getLifeIndex(location)
      this.lifeIndex = lifeIndex
    } catch (error) {
      this.errorMessage = (error as Error).message || '获取生活指数失败'
    } finally {
      this.isLoading = false
    }
  }
  
  // 获取指数等级颜色
  getIndexLevelColor(level: string): ResourceColor {
    if (level.includes('适宜') || level.includes('优') || level.includes('良好')) {
      return Color.Green
    } else if (level.includes('较适宜') || level.includes('中等')) {
      return Color.Yellow
    } else if (level.includes('不太适宜') || level.includes('较差')) {
      return Color.Orange
    } else if (level.includes('不适宜') || level.includes('很差')) {
      return Color.Red
    } else {
      return Color.Gray
    }
  }
  
  build() {
    Column() {
      // 页面标题
      Row() {
        Text('健康生活建议')
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
              this.loadLifeIndex()
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
      // 生活指数数据展示
      else {
        Scroll() {
          Column() {
            // 穿衣指数
            LifeIndexItemView(this, '穿衣', this.lifeIndex.clothes)
            
            // 雨伞指数
            LifeIndexItemView(this, '雨伞', this.lifeIndex.umbrella)
            
            // 运动指数
            LifeIndexItemView(this, '运动', this.lifeIndex.sports)
            
            // 洗车指数
            LifeIndexItemView(this, '洗车', this.lifeIndex.carWash)
            
            // 感冒指数
            LifeIndexItemView(this, '感冒', this.lifeIndex.coldRisk)
            
            // 钓鱼指数
            LifeIndexItemView(this, '钓鱼', this.lifeIndex.fishing)
            
            // 防晒指数
            LifeIndexItemView(this, '防晒', this.lifeIndex.sunscreen)
          }
          .padding({ left: 20, right: 20, bottom: 20 })
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
}

// 生活指数项组件
@Builder
function LifeIndexItemView(page: LifeAdvicePage, name: string, indexItem: LifeIndexItem) {
  Column() {
    Row() {
      Text(name)
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .layoutWeight(1)
        .fontColor(Color.White)

      // 显示等级描述（如“舒适”），不再展示数字等级避免混淆
      Text(indexItem.description || '—')
        .fontSize(16)
        .fontWeight(FontWeight.Medium)
        .fontColor(page.getIndexLevelColor(indexItem.description || indexItem.level))
    }
    .margin({ bottom: 10 })
    
    Text(indexItem.advice)
      .fontSize(14)
      .fontColor('#E8F3FF')
  }
  .padding({ top: 16, bottom: 16, left: 18, right: 18 })
  .backgroundColor('rgba(255,255,255,0.20)')
  .borderRadius(20)
  .shadow({ radius: 12, color: 'rgba(0,0,0,0.15)', offsetX: 0, offsetY: 6 })
  .margin({ bottom: 15 })
}