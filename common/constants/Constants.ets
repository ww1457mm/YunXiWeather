/**
 * 应用级别常量定义
 */
export default class Constants {
  // API相关常量
  static readonly API_KEY: string = 'your_api_key_here'; // 替换为实际API Key
  static readonly API_BASE_URL: string = 'https://api.weather.com/v1'; // 替换为实际API地址
  static readonly REQUEST_TIMEOUT: number = 10000; // 请求超时时间(毫秒)

  // 缓存相关常量
  static readonly CACHE_PREFERENCES_NAME: string = 'weather_cache';
  static readonly WEATHER_DATA_CACHE_KEY_PREFIX: string = 'weather_data_';
  static readonly CITY_LIST_CACHE_KEY: string = 'city_list';
  static readonly LOCATION_CITY_CACHE_KEY: string = 'location_city';

  // 城市收藏限制
  static readonly MAX_FAVORITE_CITIES: number = 3;

  // 数据更新频率(毫秒)
  static readonly WEATHER_UPDATE_INTERVAL: number = 15 * 60 * 1000; // 15分钟
  static readonly AIR_QUALITY_UPDATE_INTERVAL: number = 30 * 60 * 1000; // 30分钟

  // 天气图标映射
  static readonly WEATHER_ICON_MAP: Map<string, string> = new Map([
    ['CLEAR_DAY', 'icon_sunny.png'],
    ['CLEAR_NIGHT', 'icon_clear_night.png'],
    ['PARTLY_CLOUDY_DAY', 'icon_partly_cloudy_day.png'],
    ['PARTLY_CLOUDY_NIGHT', 'icon_partly_cloudy_night.png'],
    ['CLOUDY', 'icon_cloudy.png'],
    ['LIGHT_RAIN', 'icon_light_rain.png'],
    ['MODERATE_RAIN', 'icon_moderate_rain.png'],
    ['HEAVY_RAIN', 'icon_heavy_rain.png'],
    ['STORM_RAIN', 'icon_storm_rain.png'],
    ['LIGHT_SNOW', 'icon_light_snow.png'],
    ['MODERATE_SNOW', 'icon_moderate_snow.png'],
    ['HEAVY_SNOW', 'icon_heavy_snow.png'],
    ['STORM_SNOW', 'icon_storm_snow.png'],
    ['FOG', 'icon_fog.png'],
    ['HAZE', 'icon_haze.png'],
    ['WIND', 'icon_wind.png'],
    ['SAND', 'icon_sand.png'],
    ['DUST', 'icon_dust.png'],
    ['THUNDER', 'icon_thunder.png']
  ]);

  // 空气质量等级颜色映射
  static readonly AIR_QUALITY_COLOR_MAP: Map<number, string> = new Map([
    [1, '#009966'], // 优 - 绿色
    [2, '#FFD700'], // 良 - 黄色
    [3, '#FF7E00'], // 轻度污染 - 橙色
    [4, '#CC0033'], // 中度污染 - 红色
    [5, '#7E0023'], // 重度污染 - 紫红色
    [6, '#7E0023']  // 严重污染 - 紫红色
  ]);

  // 空气质量等级文本映射
  static readonly AIR_QUALITY_LEVEL_MAP: Map<number, string> = new Map([
    [1, '优'],
    [2, '良'],
    [3, '轻度污染'],
    [4, '中度污染'],
    [5, '重度污染'],
    [6, '严重污染']
  ]);
}