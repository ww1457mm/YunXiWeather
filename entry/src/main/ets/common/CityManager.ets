/**
 * 城市管理器
 * 负责城市定位、搜索、收藏等功能
 */

import { CityInfo } from './WeatherDataModel'
import { searchCity } from './WeatherAPI'

export class CityManager {
  // 单例模式：确保全局只有一个实例
  private static instance: CityManager | null = null
  
  // 默认热门城市
  private static readonly HOT_CITIES: string[] = [
    '北京', '上海', '广州', '深圳', '杭州', 
    '南京', '武汉', '成都', '重庆', '西安'
  ]

  // 默认城市：梧州（作为应用初始显示城市）
  private static readonly DEFAULT_CITY: CityInfo = {
    id: '101300601',
    name: '梧州',
    latitude: 23.48,
    longitude: 111.32,
    isFavorite: false
  }
  
  // 收藏的城市列表（最多3个）
  private favoriteCities: CityInfo[] = []
  
  // 当前城市
  private currentCity: CityInfo | null = CityManager.DEFAULT_CITY
  
  // 私有构造函数，防止外部直接创建实例
  private constructor() {}
  
  /**
   * 获取单例实例
   * @returns CityManager
   */
  static getInstance(): CityManager {
    if (CityManager.instance === null) {
      CityManager.instance = new CityManager()
    }
    return CityManager.instance
  }
  
  /**
   * 获取热门城市列表
   * @returns string[]
   */
  getHotCities(): string[] {
    return CityManager.HOT_CITIES
  }
  
  /**
   * 搜索城市
   * @param cityName 城市名称
   * @returns Promise<CityInfo[]>
   */
  async searchCity(cityName: string): Promise<CityInfo[]> {
    try {
      const cities = await searchCity(cityName)
      return cities
    } catch (error) {
      throw new Error(`搜索城市失败: ${(error as Error).message}`)
    }
  }
  
  /**
   * 添加收藏城市
   * @param city 城市信息
   * @returns boolean 是否添加成功
   */
  addFavoriteCity(city: CityInfo): boolean {
    // 检查是否已收藏
    const exists = this.favoriteCities.some(favCity => favCity.id === city.id)
    if (exists) {
      return false
    }
    
    // 检查收藏数量限制
    if (this.favoriteCities.length >= 3) {
      throw new Error('最多只能收藏3个城市')
    }
    
    // 添加到收藏列表
    this.favoriteCities.push(city)
    return true
  }
  
  /**
   * 移除收藏城市
   * @param cityId 城市ID
   * @returns boolean 是否移除成功
   */
  removeFavoriteCity(cityId: string): boolean {
    const index = this.favoriteCities.findIndex(city => city.id === cityId)
    if (index !== -1) {
      this.favoriteCities.splice(index, 1)
      return true
    }
    return false
  }
  
  /**
   * 获取收藏的城市列表
   * @returns CityInfo[]
   */
  getFavoriteCities(): CityInfo[] {
    return this.favoriteCities
  }
  
  /**
   * 设置当前城市
   * @param city 城市信息
   */
  setCurrentCity(city: CityInfo): void {
    this.currentCity = city
  }
  
  /**
   * 获取当前城市
   * @returns CityInfo | null
   */
  getCurrentCity(): CityInfo | null {
    return this.currentCity
  }
  
  /**
   * 清空收藏城市列表
   */
  clearFavoriteCities(): void {
    this.favoriteCities = []
  }
  
  /**
   * 初始化默认收藏城市（示例）
   */
  initDefaultFavorites(): void {
    // 这里可以添加一些默认的收藏城市
    // 实际应用中可能从本地存储加载
  }
}