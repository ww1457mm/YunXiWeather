/**
 * 数据缓存工具类
 */
import dataPreferences from '@ohos.data.preferences';
import { WeatherData } from '../../model/WeatherModel.ets';
import { City } from '../../model/CityModel.ets';
import Constants from '../constants/Constants.ets';
import deviceInfo from '@ohos.deviceInfo';

export class CacheUtils {
  private static preferences: dataPreferences.Preferences | null = null;
  private static readonly CACHE_NAME: string = Constants.CACHE_PREFERENCES_NAME;

  /**
   * 初始化缓存
   */
  static async initialize(): Promise<void> {
    try {
      this.preferences = await dataPreferences.getPreferences(this.CACHE_NAME);
      console.info('Cache initialized successfully');
    } catch (error) {
      console.error(`Failed to initialize cache: ${error.message}`);
      throw error;
    }
  }

  /**
   * 保存天气数据到缓存
   * @param cityId 城市ID
   * @param data 天气数据
   */
  static async saveWeatherData(cityId: string, data: WeatherData): Promise<void> {
    if (!this.preferences) {
      await this.initialize();
    }

    try {
      const cacheKey = `${Constants.WEATHER_DATA_CACHE_KEY_PREFIX}${cityId}`;
      const cacheData = {
        ...data,
        lastUpdateTime: new Date().toISOString(), // 更新缓存时间
        expiresAt: new Date(Date.now() + Constants.WEATHER_UPDATE_INTERVAL).toISOString() // 设置过期时间
      };
      
      await this.preferences.put(cacheKey, JSON.stringify(cacheData));
      await this.preferences.flush();
      console.info(`Weather data cached for city: ${cityId}`);
    } catch (error) {
      console.error(`Failed to save weather data to cache: ${error.message}`);
      throw error;
    }
  }

  /**
   * 从缓存获取天气数据
   * @param cityId 城市ID
   * @returns 天气数据或null
   */
  static async getWeatherData(cityId: string): Promise<WeatherData | null> {
    if (!this.preferences) {
      await this.initialize();
    }

    try {
      const cacheKey = `${Constants.WEATHER_DATA_CACHE_KEY_PREFIX}${cityId}`;
      const cachedData = await this.preferences.get(cacheKey, null) as string;

      if (!cachedData) {
        console.info(`No cached weather data for city: ${cityId}`);
        return null;
      }

      const parsedData: WeatherData = JSON.parse(cachedData);

      // 检查缓存是否过期
      if (this.isCacheExpired(parsedData.expiresAt)) {
        console.info(`Cached weather data expired for city: ${cityId}`);
        await this.removeWeatherData(cityId); // 删除过期数据
        return null;
      }

      console.info(`Weather data retrieved from cache for city: ${cityId}`);
      return parsedData;
    } catch (error) {
      console.error(`Failed to get weather data from cache: ${error.message}`);
      return null;
    }
  }

  /**
   * 删除指定城市的天气缓存
   * @param cityId 城市ID
   */
  static async removeWeatherData(cityId: string): Promise<void> {
    if (!this.preferences) {
      return;
    }

    try {
      const cacheKey = `${Constants.WEATHER_DATA_CACHE_KEY_PREFIX}${cityId}`;
      await this.preferences.delete(cacheKey);
      await this.preferences.flush();
      console.info(`Weather data cache removed for city: ${cityId}`);
    } catch (error) {
      console.error(`Failed to remove weather data from cache: ${error.message}`);
      throw error;
    }
  }

  /**
   * 保存城市列表到缓存
   * @param cities 城市列表
   */
  static async saveCityList(cities: City[]): Promise<void> {
    if (!this.preferences) {
      await this.initialize();
    }

    try {
      await this.preferences.put(Constants.CITY_LIST_CACHE_KEY, JSON.stringify(cities));
      await this.preferences.flush();
      console.info('City list cached successfully');
    } catch (error) {
      console.error(`Failed to save city list to cache: ${error.message}`);
      throw error;
    }
  }

  /**
   * 从缓存获取城市列表
   * @returns 城市列表或空数组
   */
  static async getCityList(): Promise<City[]> {
    if (!this.preferences) {
      await this.initialize();
    }

    try {
      const cachedData = await this.preferences.get(Constants.CITY_LIST_CACHE_KEY, '[]') as string;
      const cities: City[] = JSON.parse(cachedData);
      
      console.info(`City list retrieved from cache, count: ${cities.length}`);
      return cities;
    } catch (error) {
      console.error(`Failed to get city list from cache: ${error.message}`);
      return [];
    }
  }

  /**
   * 保存定位城市到缓存
   * @param city 定位城市信息
   */
  static async saveLocationCity(city: City): Promise<void> {
    if (!this.preferences) {
      await this.initialize();
    }

    try {
      await this.preferences.put(Constants.LOCATION_CITY_CACHE_KEY, JSON.stringify(city));
      await this.preferences.flush();
      console.info('Location city cached successfully');
    } catch (error) {
      console.error(`Failed to save location city to cache: ${error.message}`);
      throw error;
    }
  }

  /**
   * 从缓存获取定位城市
   * @returns 定位城市或null
   */
  static async getLocationCity(): Promise<City | null> {
    if (!this.preferences) {
      await this.initialize();
    }

    try {
      const cachedData = await this.preferences.get(Constants.LOCATION_CITY_CACHE_KEY, null) as string;
      
      if (!cachedData) {
        console.info('No cached location city');
        return null;
      }

      const city: City = JSON.parse(cachedData);
      console.info('Location city retrieved from cache');
      return city;
    } catch (error) {
      console.error(`Failed to get location city from cache: ${error.message}`);
      return null;
    }
  }

  /**
   * 检查缓存是否过期
   * @param expiresAt 过期时间字符串
   * @returns 是否过期
   */
  private static isCacheExpired(expiresAt: string): boolean {
    if (!expiresAt) {
      return true;
    }

    try {
      const expireTime = new Date(expiresAt).getTime();
      const currentTime = Date.now();
      return currentTime > expireTime;
    } catch (error) {
      console.error(`Failed to check cache expiration: ${error.message}`);
      return true; // 如果解析失败，默认认为已过期
    }
  }

  /**
   * 清除所有缓存
   */
  static async clearAllCache(): Promise<void> {
    if (!this.preferences) {
      await this.initialize();
    }

    try {
      // 获取所有键值
      const allKeys = await this.preferences.getAll();
      for (const key in allKeys) {
        await this.preferences.delete(key);
      }
      await this.preferences.flush();
      console.info('All cache cleared');
    } catch (error) {
      console.error(`Failed to clear cache: ${error.message}`);
      throw error;
    }
  }

  /**
   * 获取缓存大小信息（近似值）
   * @returns 缓存大小信息
   */
  static async getCacheInfo(): Promise<{ size: number, keys: number }> {
    if (!this.preferences) {
      await this.initialize();
    }

    try {
      const allData = await this.preferences.getAll();
      const keys = Object.keys(allData);
      let size = 0;

      for (const key of keys) {
        const value = allData[key];
        size += key.length * 2; // 估算键的大小
        if (typeof value === 'string') {
          size += value.length * 2; // 估算值的大小
        } else {
          size += JSON.stringify(value).length * 2;
        }
      }

      return { size, keys: keys.length };
    } catch (error) {
      console.error(`Failed to get cache info: ${error.message}`);
      return { size: 0, keys: 0 };
    }
  }
}