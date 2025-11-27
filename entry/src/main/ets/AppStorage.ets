/**
 * 云犀天气 - 全局状态管理
 */

import { City } from './model/CityModel';
import { WeatherData } from './model/WeatherModel';

// 定义全局状态变量
let currentCity: City = {
  id: '101010100',
  name: '北京',
  lat: '39.904989',
  lon: '116.405285',
  isCurrent: true
};

let weatherData: WeatherData | null = null;
let favoriteCities: City[] = [];
let isLoading: boolean = false;
let lastUpdate: number = 0;

// 全局状态管理器
class GlobalState {
  private static instance: GlobalState;

  private constructor() {}

  public static getInstance(): GlobalState {
    if (!GlobalState.instance) {
      GlobalState.instance = new GlobalState();
    }
    return GlobalState.instance;
  }

  // 获取和设置当前城市
  getCurrentCity(): City {
    return currentCity;
  }

  setCurrentCity(city: City): void {
    currentCity = city;
    this.notifyStateChange('currentCity');
  }

  // 获取和设置天气数据
  getWeatherData(): WeatherData | null {
    return weatherData;
  }

  setWeatherData(data: WeatherData): void {
    weatherData = data;
    lastUpdate = Date.now();
    this.notifyStateChange('weatherData');
  }

  // 获取收藏城市
  getFavoriteCities(): City[] {
    return favoriteCities;
  }

  setFavoriteCities(cities: City[]): void {
    favoriteCities = cities;
    this.notifyStateChange('favoriteCities');
  }

  addFavoriteCity(city: City): void {
    if (favoriteCities.length >= 3) {
      favoriteCities.shift(); // 保持最多3个
    }
    favoriteCities.push(city);
    this.notifyStateChange('favoriteCities');
  }

  removeFavoriteCity(cityId: string): void {
    favoriteCities = favoriteCities.filter(city => city.id !== cityId);
    this.notifyStateChange('favoriteCities');
  }

  // 加载状态
  getIsLoading(): boolean {
    return isLoading;
  }

  setIsLoading(loading: boolean): void {
    isLoading = loading;
    this.notifyStateChange('isLoading');
  }

  // 最后更新时间
  getLastUpdate(): number {
    return lastUpdate;
  }

  // 通知状态变更
  private notifyStateChange(key: string): void {
    // 实际应用中可实现观察者模式
    console.log(`State changed: ${key}`);
  }
}

// 导出单例
export const globalState = GlobalState.getInstance();

// 默认初始化
globalState.setCurrentCity(currentCity);