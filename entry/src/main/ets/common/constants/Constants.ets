/**
 * 云犀天气 - 常量定义
 */
import { City } from "../../model/CityModel";

// 在文件顶部或适当位置添加接口定义
export interface HealthTipsConfig {
  CLOTHES: string;
  SUNSCREEN: string;
  UMBRELLA: string;
  SPORTS: string;
  FISHING: string;
  CAR_WASH: string;
  COLD: string;
}
// 空气质量等级
export interface AirQualityLevel {
  name: string;
  colorKey: string;
  max: number;
}

// API配置
export const API_BASE_URL = 'https://devapi.qweather.com/v7';
export const API_KEY = 'b30abe309e99457cbf320e9806aeec41'; // 请替换为实际API密钥

// 缓存配置
export const WEATHER_CACHE_EXPIRY = 30 * 60 * 1000; // 30分钟
export const CITY_CACHE_EXPIRY = 24 * 60 * 60 * 1000; // 24小时
export const LOCATION_CACHE_EXPIRY = 12 * 60 * 60 * 1000; // 12小时

// 定位配置
export const LOCATION_TIMEOUT = 10000; // 10秒超时

// 默认城市
export const DEFAULT_CITY :City= {
  id: '101010100',
  name: '北京',
  lat: '39.904989',
  lon: '116.405285',
  isCurrent: true
};

// 天气图标映射
export const WEATHER_ICONS: Record<string, string> = {
  '100': 'icon_sunny',
  '101': 'icon_cloudy',
  '102': 'icon_cloudy',
  '103': 'icon_cloudy',
  '104': 'icon_cloudy',
  '300': 'icon_rain',
  '301': 'icon_rain',
  '302': 'icon_rain',
  '303': 'icon_rain',
  '304': 'icon_rain',
  '305': 'icon_rain',
  '306': 'icon_rain',
  '307': 'icon_rain',
  '308': 'icon_rain',
  '309': 'icon_rain',
  '310': 'icon_rain',
  '311': 'icon_rain',
  '312': 'icon_rain',
  '313': 'icon_rain',
  '314': 'icon_snow',
  '315': 'icon_snow',
  '316': 'icon_snow',
  '317': 'icon_snow',
  '318': 'icon_snow',
  '399': 'icon_rain',
  '400': 'icon_snow',
  '401': 'icon_snow',
  '402': 'icon_snow',
  '403': 'icon_snow',
  '404': 'icon_snow',
  '405': 'icon_rain',
  '406': 'icon_snow',
  '407': 'icon_rain',
  '408': 'icon_snow',
  '500': 'icon_wind',
  '501': 'icon_fog',
  '502': 'icon_fog',
  '503': 'icon_fog',
  '504': 'icon_fog',
  '507': 'icon_fog',
  '508': 'icon_fog',
  '900': 'icon_cloudy',
  '901': 'icon_cloudy',
  '999': 'icon_cloudy'
};

// 健康提示类型
export const HEALTH_TIPS : HealthTipsConfig= {
  CLOTHES: 'clothes',
  SUNSCREEN: 'sunscreen',
  UMBRELLA: 'umbrella',
  SPORTS: 'sports',
  FISHING: 'fishing',
  CAR_WASH: 'car_wash',
  COLD: 'cold'
};


export const AIR_QUALITY_LEVELS: AirQualityLevel[] = [
  { name: '优', colorKey: 'app.color.air_quality_good', max: 50 },
  { name: '良', colorKey: 'app.color.air_quality_normal', max: 100 },
  { name: '轻度污染', colorKey: 'app.color.air_quality_poor', max: 150 },
  { name: '中度污染', colorKey: 'app.color.air_quality_bad', max: 200 },
  { name: '重度污染', colorKey: 'app.color.air_quality_worse', max: 300 },
  { name: '严重污染', colorKey: 'app.color.air_quality_hazardous', max: 500 }
];

// 天气类型映射
export const WEATHER_TYPES: Record<string, string> = {
  'sunny': '晴',
  'cloudy': '多云',
  'rain': '雨',
  'snow': '雪',
  'fog': '雾',
  'wind': '风'
};