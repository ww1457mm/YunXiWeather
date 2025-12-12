/**
 * 缓存管理器
 * 实现离线缓存机制,确保在网络不稳定时仍能显示最近的天气数据
 */

import { CurrentWeather, HourlyForecast, DailyForecast, AirQuality, LifeIndex, ExtremeWeatherWarning } from './WeatherDataModel'
import preferences from '@ohos.data.preferences'
import { common } from '@kit.AbilityKit'

export class CacheManager {
  // 缓存键名常量
  private static readonly CACHE_KEY_CURRENT_WEATHER = 'current_weather'
  private static readonly CACHE_KEY_HOURLY_FORECAST = 'hourly_forecast'
  private static readonly CACHE_KEY_DAILY_FORECAST = 'daily_forecast'
  private static readonly CACHE_KEY_AIR_QUALITY = 'air_quality'
  private static readonly CACHE_KEY_LIFE_INDEX = 'life_index'
  private static readonly CACHE_KEY_EXTREME_WARNINGS = 'extreme_warnings'
  private static readonly CACHE_KEY_LAST_UPDATE = 'last_update'
  
  // 缓存有效期（毫秒）- 默认2小时
  private static readonly CACHE_EXPIRY_TIME = 2 * 60 * 60 * 1000
  
  // Context 对象
  private context: common.UIAbilityContext
  
  constructor(context: common.UIAbilityContext) {
    this.context = context
  }
  
  /**
   * 保存实时天气数据到缓存
   * @param data 实时天气数据
   */
  async saveCurrentWeather(data: CurrentWeather): Promise<void> {
    await this.saveToStorage(CacheManager.CACHE_KEY_CURRENT_WEATHER, data)
    await this.updateLastUpdateTime()
  }
  
  /**
   * 从缓存获取实时天气数据
   * @returns CurrentWeather | null
   */
  async getCurrentWeather(): Promise<CurrentWeather | null> {
    if (await this.isCacheExpired()) {
      return null
    }
    const data = await this.getFromStorage(CacheManager.CACHE_KEY_CURRENT_WEATHER)
    return data as CurrentWeather | null
  }
  
  /**
   * 保存小时预报数据到缓存
   * @param data 小时预报数据
   */
  async saveHourlyForecast(data: HourlyForecast[]): Promise<void> {
    await this.saveToStorage(CacheManager.CACHE_KEY_HOURLY_FORECAST, data)
    await this.updateLastUpdateTime()
  }
  
  /**
   * 从缓存获取小时预报数据
   * @returns HourlyForecast[] | null
   */
  async getHourlyForecast(): Promise<HourlyForecast[] | null> {
    if (await this.isCacheExpired()) {
      return null
    }
    const data = await this.getFromStorage(CacheManager.CACHE_KEY_HOURLY_FORECAST)
    return data as HourlyForecast[] | null
  }
  
  /**
   * 保存日预报数据到缓存
   * @param data 日预报数据
   */
  async saveDailyForecast(data: DailyForecast[]): Promise<void> {
    await this.saveToStorage(CacheManager.CACHE_KEY_DAILY_FORECAST, data)
    await this.updateLastUpdateTime()
  }
  
  /**
   * 从缓存获取日预报数据
   * @returns DailyForecast[] | null
   */
  async getDailyForecast(): Promise<DailyForecast[] | null> {
    if (await this.isCacheExpired()) {
      return null
    }
    const data = await this.getFromStorage(CacheManager.CACHE_KEY_DAILY_FORECAST)
    return data as DailyForecast[] | null
  }
  
  /**
   * 保存空气质量数据到缓存
   * @param data 空气质量数据
   */
  async saveAirQuality(data: AirQuality): Promise<void> {
    await this.saveToStorage(CacheManager.CACHE_KEY_AIR_QUALITY, data)
    await this.updateLastUpdateTime()
  }
  
  /**
   * 从缓存获取空气质量数据
   * @returns AirQuality | null
   */
  async getAirQuality(): Promise<AirQuality | null> {
    if (await this.isCacheExpired()) {
      return null
    }
    const data = await this.getFromStorage(CacheManager.CACHE_KEY_AIR_QUALITY)
    return data as AirQuality | null
  }
  
  /**
   * 保存生活指数数据到缓存
   * @param data 生活指数数据
   */
  async saveLifeIndex(data: LifeIndex): Promise<void> {
    await this.saveToStorage(CacheManager.CACHE_KEY_LIFE_INDEX, data)
    await this.updateLastUpdateTime()
  }
  
  /**
   * 从缓存获取生活指数数据
   * @returns LifeIndex | null
   */
  async getLifeIndex(): Promise<LifeIndex | null> {
    if (await this.isCacheExpired()) {
      return null
    }
    const data = await this.getFromStorage(CacheManager.CACHE_KEY_LIFE_INDEX)
    return data as LifeIndex | null
  }
  
  /**
   * 保存极端天气预警数据到缓存
   * @param data 极端天气预警数据
   */
  async saveExtremeWarnings(data: ExtremeWeatherWarning[]): Promise<void> {
    await this.saveToStorage(CacheManager.CACHE_KEY_EXTREME_WARNINGS, data)
    await this.updateLastUpdateTime()
  }
  
  /**
   * 从缓存获取极端天气预警数据
   * @returns ExtremeWeatherWarning[] | null
   */
  async getExtremeWarnings(): Promise<ExtremeWeatherWarning[] | null> {
    if (await this.isCacheExpired()) {
      return null
    }
    const data = await this.getFromStorage(CacheManager.CACHE_KEY_EXTREME_WARNINGS)
    return data as ExtremeWeatherWarning[] | null
  }
  
  /**
   * 检查缓存是否过期
   * @returns boolean
   */
  async isCacheExpired(): Promise<boolean> {
    try {
      const lastUpdate = await this.getLastUpdateTime()
      if (!lastUpdate) {
        return true
      }
      
      const now = new Date().getTime()
      return (now - lastUpdate) > CacheManager.CACHE_EXPIRY_TIME
    } catch (error) {
      return true
    }
  }
  
  /**
   * 清空所有缓存数据
   */
  async clearAllCache(): Promise<void> {
    try {
      const dataPreferences = await preferences.getPreferences(this.context, 'weather_cache')
      await dataPreferences.clear()
      await dataPreferences.flush()
    } catch (error) {
      console.error('清空缓存失败:', error)
    }
  }
  
  /**
   * 保存数据到本地存储
   * @param key 存储键名
   * @param data 要存储的数据
   */
  private async saveToStorage(key: string, data: Object): Promise<void> {
    try {
      const jsonData = JSON.stringify(data)
      const dataPreferences = await preferences.getPreferences(this.context, 'weather_cache')
      await dataPreferences.put(key, jsonData)
      await dataPreferences.flush()
    } catch (error) {
      console.error(`保存缓存失败 (${key}):`, error)
    }
  }
  
  /**
   * 从本地存储获取数据
   * @param key 存储键名
   * @returns any | null
   */
  private async getFromStorage(key: string): Promise<Object | null> {
    try {
      const dataPreferences = await preferences.getPreferences(this.context, 'weather_cache')
      const jsonData = await dataPreferences.get(key, '')
      if (jsonData) {
        return JSON.parse(jsonData as string)
      }
      return null
    } catch (error) {
      console.error(`读取缓存失败 (${key}):`, error)
      return null
    }
  }
  
  /**
   * 更新最后更新时间
   */
  private async updateLastUpdateTime(): Promise<void> {
    try {
      const now = new Date().getTime()
      const dataPreferences = await preferences.getPreferences(this.context, 'weather_cache')
      await dataPreferences.put(CacheManager.CACHE_KEY_LAST_UPDATE, now.toString())
      await dataPreferences.flush()
    } catch (error) {
      console.error('更新缓存时间失败:', error)
    }
  }
  
  /**
   * 获取最后更新时间
   * @returns number | null
   */
  private async getLastUpdateTime(): Promise<number | null> {
    try {
      const dataPreferences = await preferences.getPreferences(this.context, 'weather_cache')
      const timeStr = await dataPreferences.get(CacheManager.CACHE_KEY_LAST_UPDATE, '')
      if (timeStr) {
        return parseInt(timeStr as string)
      }
      return null
    } catch (error) {
      console.error('获取缓存时间失败:', error)
      return null
    }
  }
}