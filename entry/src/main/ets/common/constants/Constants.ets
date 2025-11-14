/**
 * 云犀天气 - 常量定义
 * 定义应用全局使用的常量，如API配置、缓存键名、UI样式常量等
 */

export default class Constants {
  // --- API 相关 ---
  /**
   * 和风天气 API 基础 URL
   * 示例: https://devapi.qweather.com/v7/weather/now
   */
  static readonly API_BASE_URL: string = 'https://devapi.qweather.com/v7';

  /**
   * 和风天气 API KEY
   * TODO: 请替换为您自己的API KEY
   */
  static readonly API_KEY: string = 'b30abe309e99457cbf320e9806aeec41'; // 请务必在此处填入您的真实API Key

  /**
   * API 请求超时时间 (毫秒)
   */
  static readonly API_REQUEST_TIMEOUT: number = 10000; // 10秒

  // --- 缓存 相关 ---
  /**
   * 本地缓存首选项名称
   */
  static readonly PREFERENCES_NAME: string = 'yunxi_weather_cache';

  /**
   * 缓存天气数据的键前缀
   * 完整键名格式: `weather_${cityId}`
   */
  static readonly CACHE_KEY_WEATHER_PREFIX: string = 'weather_';

  /**
   * 缓存城市列表的键名
   */
  static readonly CACHE_KEY_CITY_LIST: string = 'city_list';

  /**
   * 天气数据缓存过期时间 (毫秒)
   * 例如：30分钟 = 30 * 60 * 1000
   */
  static readonly CACHE_EXPIRE_TIME_WEATHER: number = 30 * 60 * 1000;

  /**
   * 城市列表缓存过期时间 (毫秒)
   * 通常城市列表变动较少，可以设置更长，这里设为1小时
   */
  static readonly CACHE_EXPIRE_TIME_CITY_LIST: number = 60 * 60 * 1000;

  // --- 城市管理 相关 ---
  /**
   * 最大收藏城市数量
   */
  static readonly MAX_SAVED_CITIES: number = 3;

  // --- 后台刷新 相关 ---
  /**
   * 后台数据刷新间隔 (毫秒)
   * 例如：1小时 = 60 * 60 * 1000
   * 注意：过于频繁的后台刷新可能影响电池寿命和API配额
   */
  static readonly BACKGROUND_REFRESH_INTERVAL: number = 60 * 60 * 1000;

  // --- UI 相关 (可根据设计稿调整) ---
  /**
   * 字体大小 - 大号 (用于城市名)
   */
  static readonly FONT_SIZE_LARGE: number = 28;

  /**
   * 字体大小 - 中号 (用于温度)
   */
  static readonly FONT_SIZE_MEDIUM: number = 24;

  /**
   * 字体大小 - 小号 (用于副标题、描述)
   */
  static readonly FONT_SIZE_SMALL: number = 16;

  // --- 权限 相关 ---
  /**
   * 定位权限名称
   */
  static readonly PERMISSION_LOCATION: string = 'ohos.permission.LOCATION';

  // --- 天气图标映射 ---
  /**
   * 天气代码到图标资源名称的映射
   * 请注意：图标文件需放在 resources/base/media 目录下
   * 此处仅为示例，实际代码需根据和风天气API返回的天气代码进行映射
   * 可能需要根据和风天气官方文档调整映射关系
   */
  static readonly WEATHER_ICON_MAP: Record<string, string> = {
    // 晴
    '0': 'icon_sunny.png',
    '1': 'icon_sunny.png', // 示例：晴天代码可能是0或1
    // 阴
    '4': 'icon_cloudy.png',
    '5': 'icon_cloudy.png',
    // 雨
    '9': 'icon_rain.png',
    '10': 'icon_rain.png',
    '11': 'icon_rain.png',
    '12': 'icon_rain.png',
    '13': 'icon_rain.png',
    // 雪
    '14': 'icon_snow.png',
    '15': 'icon_snow.png',
    '16': 'icon_snow.png',
    '17': 'icon_snow.png',
    '18': 'icon_snow.png',
    '19': 'icon_snow.png',
    '20': 'icon_snow.png',
    '21': 'icon_snow.png',
    '22': 'icon_snow.png',
    // 雾
    '23': 'icon_fog.png',
    '24': 'icon_fog.png',
    // 风
    '25': 'icon_wind.png',
    '26': 'icon_wind.png',
    '27': 'icon_wind.png',
    '28': 'icon_wind.png',
    '29': 'icon_wind.png',
    '30': 'icon_wind.png',
    '31': 'icon_wind.png',
    '32': 'icon_wind.png',
    '33': 'icon_wind.png',
    '34': 'icon_wind.png',
    '35': 'icon_wind.png',
    '36': 'icon_wind.png',
    '37': 'icon_wind.png',
    '38': 'icon_wind.png',
    '39': 'icon_wind.png',
    '40': 'icon_wind.png',
    '41': 'icon_wind.png',
    '42': 'icon_wind.png',
    '43': 'icon_wind.png',
    '44': 'icon_wind.png',
    '45': 'icon_wind.png',
    '46': 'icon_wind.png',
    '47': 'icon_wind.png',
    '48': 'icon_wind.png',
    '49': 'icon_wind.png',
    '50': 'icon_wind.png',
    '51': 'icon_wind.png',
    '52': 'icon_wind.png',
    '53': 'icon_wind.png',
    '54': 'icon_wind.png',
    '55': 'icon_wind.png',
    '56': 'icon_wind.png',
    '57': 'icon_wind.png',
    '58': 'icon_wind.png',
    '59': 'icon_wind.png',
    '60': 'icon_wind.png',
    '61': 'icon_wind.png',
    '62': 'icon_wind.png',
    '63': 'icon_wind.png',
    '64': 'icon_wind.png',
    '65': 'icon_wind.png',
    '66': 'icon_wind.png',
    '67': 'icon_wind.png',
    '68': 'icon_wind.png',
    '69': 'icon_wind.png',
    '70': 'icon_wind.png',
    '71': 'icon_wind.png',
    '72': 'icon_wind.png',
    '73': 'icon_wind.png',
    '74': 'icon_wind.png',
    '75': 'icon_wind.png',
    '76': 'icon_wind.png',
    '77': 'icon_wind.png',
    '78': 'icon_wind.png',
    '79': 'icon_wind.png',
    '80': 'icon_wind.png',
    '81': 'icon_wind.png',
    '82': 'icon_wind.png',
    '83': 'icon_wind.png',
    '84': 'icon_wind.png',
    '85': 'icon_wind.png',
    '86': 'icon_wind.png',
    '87': 'icon_wind.png',
    '88': 'icon_wind.png',
    '89': 'icon_wind.png',
    '90': 'icon_wind.png',
    '91': 'icon_wind.png',
    '92': 'icon_wind.png',
    '93': 'icon_wind.png',
    '94': 'icon_wind.png',
    '95': 'icon_wind.png',
    '96': 'icon_wind.png',
    '97': 'icon_wind.png',
    '98': 'icon_wind.png',
    '99': 'icon_wind.png',
    // 默认图标
    'default': 'icon_sunny.png', // 或者一个 'icon_unknown.png'
  };

  // --- 空气质量等级颜色映射 ---
  /**
   * 空气质量指数 (AQI) 等级到颜色的映射
   * 用于 AirQualityBadge 组件
   */
  static readonly AIR_QUALITY_COLOR_MAP: Record<string, string> = {
    '优': '#00E676', // 绿色
    '良': '#FFEB3B', // 黄色
    '轻度污染': '#FF9800', // 橙色
    '中度污染': '#F44336', // 红色
    '重度污染': '#7B1FA2', // 紫色
    '严重污染': '#7B1FA2', // 紫色 (或更深)
    'default': '#9E9E9E', // 灰色，用于未知或无数据情况
  };
}
