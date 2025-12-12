import { CityManager } from '../../common/CityManager'
import { CityInfo } from '../../common/WeatherDataModel'
import router from '@ohos.router'

@Entry
@Component
struct CityPage {
  @State cityName: string = ''
  @State searchResults: CityInfo[] = []
  @State errorMessage: string = ''
  @State isSearching: boolean = false
  @State hotCities: string[] = []
  
  private cityManager: CityManager = CityManager.getInstance()
  
  aboutToAppear(): void {
    this.hotCities = this.cityManager.getHotCities()
  }
  
  // 搜索城市
  async searchCity() {
    if (!this.cityName.trim()) {
      return
    }
    
    this.isSearching = true
    this.errorMessage = ''
    this.searchResults = []
    
    try {
      const results = await this.cityManager.searchCity(this.cityName)
      if (results.length > 0) {
        this.searchResults = results
      } else {
        this.errorMessage = '未找到该城市'
      }
    } catch (error) {
      this.errorMessage = (error as Error).message || '未找到该城市,请重试'
    } finally {
      this.isSearching = false
    }
  }
  
  // 选择城市
  selectCity(city: CityInfo) {
    this.cityManager.setCurrentCity(city)
    // 返回主页并刷新天气数据
    router.back()
  }
  
  // 选择热门城市
  async selectHotCity(cityName: string) {
    this.cityName = cityName
    await this.searchCity()
  }
  
  build() {
    Stack() {
      Image($r('app.media.gradient_bg'))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Fill)
      
      Column() {
        // 页面标题
        Row() {
          Text('城市管理')
            .fontSize(24)
            .fontWeight(FontWeight.Bold)
            .fontColor(Color.White)
            .margin({ top: 20, bottom: 20 })
        }
        .padding({ left: 20, right: 20 })
        
        // 搜索框
        Row() {
          TextInput({ 
            text: this.cityName, 
            placeholder: '搜索城市' 
          })
          .onChange((value: string) => {
            this.cityName = value
          })
          .layoutWeight(1)
          .height(44)
          .backgroundColor('rgba(255,255,255,0.20)')
          .backdropBlur(20)
          .border({ width: 1, color: 'rgba(255,255,255,0.3)' })
          .borderRadius(16)
          .margin({ right: 10 })
          .fontColor(Color.White)
          .placeholderColor('rgba(255,255,255,0.7)')
          
          Button('搜索')
            .onClick(() => {
              this.searchCity()
            })
            .height(44)
            .backgroundColor('rgba(255,255,255,0.2)')
            .backdropBlur(20)
            .border({ width: 1, color: 'rgba(255,255,255,0.3)' })
            .fontColor(Color.White)
            .borderRadius(16)
        }
        .padding({ left: 20, right: 20 })
        .margin({ bottom: 20 })
        
        // 错误提示
        if (this.errorMessage) {
          Text(this.errorMessage)
            .fontColor('#FFD1D1')
            .fontSize(14)
            .margin({ bottom: 10 })
        }
        
        // 搜索结果
        if (this.searchResults.length > 0) {
          Column() {
            Text('搜索结果')
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .fontColor(Color.White)
              .margin({ bottom: 10 })
            
            ForEach(this.searchResults, (city: CityInfo) => {
              Row() {
                Text(city.name)
                  .fontSize(16)
                  .fontColor(Color.White)
                  .layoutWeight(1)
                
                Button('选择')
                  .onClick(() => {
                    this.selectCity(city)
                  })
                  .fontSize(14)
                  .backgroundColor('rgba(255,255,255,0.2)')
                  .backdropBlur(20)
                  .border({ width: 1, color: 'rgba(255,255,255,0.3)' })
                  .fontColor(Color.White)
                  .borderRadius(16)
              }
              .padding({ left: 16, right: 16, top: 10, bottom: 10 })
              .backgroundColor('rgba(255,255,255,0.2)')
              .backdropBlur(20)
              .border({ width: 1, color: 'rgba(255,255,255,0.3)' })
              .borderRadius(16)
              .margin({ bottom: 10 })
            }, (item: CityInfo) => item.id)
          }
          .layoutWeight(1)
          .padding({ left: 20, right: 20 })
        } else if (this.isSearching) {
          // 加载中提示
          Column() {
            Text('加载中...')
              .fontSize(16)
              .fontColor(Color.White)
          }
          .layoutWeight(1)
          .justifyContent(FlexAlign.Center)
        } else {
          // 热门城市
          Column() {
            Text('热门城市')
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .fontColor(Color.White)
              .margin({ bottom: 10 })
            
            Grid() {
              ForEach(this.hotCities, (city: string) => {
                GridItem() {
                  Button(city)
                    .onClick(() => {
                      this.selectHotCity(city)
                    })
                    .width('100%')
                    .backgroundColor('rgba(255,255,255,0.2)')
                    .backdropBlur(20)
                    .border({ width: 1, color: 'rgba(255,255,255,0.3)' })
                    .fontColor(Color.White)
                    .borderRadius(18)
                }
                .aspectRatio(2)
              }, (item: string) => item)
            }
            .columnsTemplate('1fr 1fr 1fr')
            .rowsGap(12)
            .columnsGap(12)
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
            .height(44)
            .backgroundColor('rgba(255,255,255,0.2)')
            .backdropBlur(20)
            .border({ width: 1, color: 'rgba(255,255,255,0.3)' })
            .fontColor(Color.White)
            .borderRadius(20)
        }
        .justifyContent(FlexAlign.Center)
        .margin({ top: 20, bottom: 20 })
      }
      .width('100%')
      .height('100%')
    }
    .width('100%')
    .height('100%')
  }
}