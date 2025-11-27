/**
 * 云犀天气 - 字符串工具类
 */

// 日期格式化
export class StringUtils {
  /**
   * 格式化日期为"今天"、"明天"等友好显示
   * @param dateStr 日期字符串 (格式: YYYY-MM-DD)
   * @param today 今天的日期（可选，用于测试）
   * @returns 友好日期字符串
   */
  static formatFriendlyDate(dateStr: string, today?: Date): string {
    if (!dateStr) return '';

    const date = new Date(dateStr);
    const now = today || new Date();

    // 重置时间为0点进行比较
    const todayStart = new Date(now.getFullYear(), now.getMonth(), now.getDate());
    const targetDate = new Date(date.getFullYear(), date.getMonth(), date.getDate());

    const diffDays = Math.floor((targetDate.getTime() - todayStart.getTime()) / (1000 * 60 * 60 * 24));

    switch (diffDays) {
      case 0:
        return $r('app.string.today').toString();
      case 1:
        return $r('app.string.tomorrow').toString();
      case -1:
        return $r('app.string.yesterday').toString();
      default:
      // 返回星期几
        const days = [
          $r('app.string.sunday').toString(),
          $r('app.string.monday').toString(),
          $r('app.string.tuesday').toString(),
          $r('app.string.wednesday').toString(),
          $r('app.string.thursday').toString(),
          $r('app.string.friday').toString(),
          $r('app.string.saturday').toString()
        ];
        return days[date.getDay()];
    }
  }

  /**
   * 格式化完整日期 (MM/DD)
   * @param dateStr 日期字符串
   * @returns 格式化后的日期
   */
  static formatDate(dateStr: string): string {
    if (!dateStr) return '';

    const date = new Date(dateStr);
    const month = date.getMonth() + 1;
    const day = date.getDate();

    return `${month.toString().padStart(2, '0')}/${day.toString().padStart(2, '0')}`;
  }

  /**
   * 格式化时间 (HH:mm)
   * @param timeStr 时间字符串
   * @returns 格式化后的时间
   */
  static formatTime(timeStr: string): string {
    if (!timeStr) return '';

    const time = timeStr.split('T')[1]?.split('+')[0] || timeStr;
    const timeParts = time.split(':');
    const hours = timeParts[0];
    const minutes = timeParts[1];

    if (!hours || !minutes) return timeStr;

    return `${hours.padStart(2, '0')}:${minutes.padStart(2, '0')}`;
  }

  /**
   * 格式化温度，添加℃符号
   * @param temp 温度值
   * @param decimals 小数位数
   * @returns 格式化后的温度
   */
  static formatTemperature(temp: string | number, decimals: number = 0): string {
    if (temp === null || temp === undefined || temp === '') return '--℃';

    const num = typeof temp === 'string' ? parseFloat(temp) : temp;
    if (isNaN(num)) return '--℃';

    return `${num.toFixed(decimals)}℃`;
  }

  /**
   * 格式化风速/风力
   * @param windDir 风向
   * @param windScale 风力等级
   * @returns 格式化后的风力描述
   */
  static formatWind(windDir: string, windScale: string): string {
    if (!windDir || !windScale) return $r('app.string.no_wind').toString();

    // 风向简写
    const directionMap: Record<string, string> = {
      '北': 'N', '东北': 'NE', '东': 'E', '东南': 'SE',
      '南': 'S', '西南': 'SW', '西': 'W', '西北': 'NW'
    };

    const dirAbbr = directionMap[windDir] || windDir.substring(0, 1);
    return `${dirAbbr} ${windScale}${$r('app.string.wind_level').toString()}`;
  }

  /**
   * 格式化湿度
   * @param humidity 湿度值
   * @returns 格式化后的湿度
   */
  static formatHumidity(humidity: string): string {
    if (!humidity) return '--%';
    return `${humidity}%`;
  }

  /**
   * 格式化AQI
   * @param aqi AQI值
   * @returns 格式化后的AQI
   */
  static formatAQI(aqi: string): string {
    if (!aqi || aqi === '0') return '--';
    return aqi;
  }

  /**
   * 简化城市名称（移除"市"、"县"等后缀）
   * @param cityName 城市名称
   * @returns 简化后的城市名
   */
  static simplifyCityName(cityName: string): string {
    if (!cityName) return '';

    return cityName
      .replace(/市$/, '')
      .replace(/县$/, '')
      .replace(/区$/, '')
      .replace(/自治州$/, '')
      .replace(/特别行政区$/, '');
  }

  /**
   * 格式化降水概率
   * @param pop 降水概率
   * @returns 格式化后的降水概率
   */
  static formatPrecipitation(pop: string): string {
    if (!pop) return '--%';
    const num = parseInt(pop);
    if (isNaN(num)) return '--%';
    return `${num}%`;
  }
}