/**
 * 网络请求工具类
 */
import http from '@ohos.net.http';
import Constants from '../constants/Constants.ets';

export class NetworkUtils {
  private static readonly DEFAULT_TIMEOUT: number = Constants.REQUEST_TIMEOUT;
  private static readonly HTTP_CLIENT: http.HttpRequest = http.createHttp();

  /**
   * 通用HTTP请求方法
   * @param url 请求URL
   * @param options 请求选项
   * @returns Promise<http.Response>
   */
  static async httpRequest(url: string, options: http.HttpRequestOptions): Promise<http.Response> {
    return new Promise((resolve, reject) => {
      // 设置默认选项
      const requestOptions: http.HttpRequestOptions = {
        method: http.RequestMethod.GET,
        ...options,
        extraData: {
          ...options.extraData,
          timeout: options.timeout || NetworkUtils.DEFAULT_TIMEOUT
        }
      };

      try {
        // 发起网络请求
        NetworkUtils.HTTP_CLIENT.request(url, requestOptions, (error, data) => {
          if (error) {
            console.error(`Network request failed: ${error.message}`);
            reject(this.handleError(error));
          } else {
            if (data && data.result === 200) {
              console.info(`Network request successful: ${url}`);
              resolve(data);
            } else {
              console.error(`Network request failed with status: ${data?.result}`);
              reject(this.handleResponseError(data));
            }
          }
        });
      } catch (error) {
        console.error(`Network request exception: ${error.message}`);
        reject(this.handleError(error));
      }
    });
  }

  /**
   * GET请求
   * @param url 请求URL
   * @param headers 请求头
   * @param timeout 超时时间
   * @returns Promise<http.Response>
   */
  static async get(url: string, headers?: {[key: string]: string}, timeout?: number): Promise<http.Response> {
    const options: http.HttpRequestOptions = {
      method: http.RequestMethod.GET,
      header: headers,
      extraData: timeout ? { timeout } : undefined
    };
    return this.httpRequest(url, options);
  }

  /**
   * POST请求
   * @param url 请求URL
   * @param data 请求数据
   * @param headers 请求头
   * @param timeout 超时时间
   * @returns Promise<http.Response>
   */
  static async post(url: string, data: any, headers?: {[key: string]: string}, timeout?: number): Promise<http.Response> {
    const options: http.HttpRequestOptions = {
      method: http.RequestMethod.POST,
      header: headers,
      extraData: {
        ...data,
        timeout: timeout || NetworkUtils.DEFAULT_TIMEOUT
      }
    };
    return this.httpRequest(url, options);
  }

  /**
   * PUT请求
   * @param url 请求URL
   * @param data 请求数据
   * @param headers 请求头
   * @param timeout 超时时间
   * @returns Promise<http.Response>
   */
  static async put(url: string, data: any, headers?: {[key: string]: string}, timeout?: number): Promise<http.Response> {
    const options: http.HttpRequestOptions = {
      method: http.RequestMethod.PUT,
      header: headers,
      extraData: {
        ...data,
        timeout: timeout || NetworkUtils.DEFAULT_TIMEOUT
      }
    };
    return this.httpRequest(url, options);
  }

  /**
   * DELETE请求
   * @param url 请求URL
   * @param headers 请求头
   * @param timeout 超时时间
   * @returns Promise<http.Response>
   */
  static async delete(url: string, headers?: {[key: string]: string}, timeout?: number): Promise<http.Response> {
    const options: http.HttpRequestOptions = {
      method: http.RequestMethod.DELETE,
      header: headers,
      extraData: timeout ? { timeout } : undefined
    };
    return this.httpRequest(url, options);
  }

  /**
   * 处理网络错误
   * @param error 错误对象
   * @returns 格式化后的错误信息
   */
  private static handleError(error: any): any {
    let errorMessage = 'Network request failed';
    
    if (error.code) {
      errorMessage += `: Code ${error.code}`;
    }
    
    if (error.message) {
      errorMessage += ` - ${error.message}`;
    }

    return {
      success: false,
      code: error.code || -1,
      message: errorMessage,
      data: null
    };
  }

  /**
   * 处理响应错误
   * @param response 响应对象
   * @returns 格式化后的错误信息
   */
  private static handleResponseError(response: http.Response): any {
    let errorMessage = `Request failed with status ${response?.result || 'unknown'}`;
    
    if (response?.header) {
      errorMessage += ` - Headers: ${JSON.stringify(response.header)}`;
    }
    
    if (response?.response) {
      errorMessage += ` - Response: ${JSON.stringify(response.response)}`;
    }

    return {
      success: false,
      code: response?.result || -1,
      message: errorMessage,
      data: null
    };
  }

  /**
   * 统一响应格式解析
   * @param response 网络响应
   * @returns 解析后的数据
   */
  static parseResponse(response: http.Response): any {
    if (response && response.result === 200 && response.header) {
      try {
        // 假设API返回JSON格式数据
        const contentType = response.header['Content-Type'] || response.header['content-type'];
        
        if (contentType && contentType.includes('application/json')) {
          // 解析JSON响应
          const jsonData = JSON.parse(response.response as string);
          return {
            success: true,
            code: 0,
            message: 'Success',
            data: jsonData
          };
        } else {
          // 非JSON响应直接返回
          return {
            success: true,
            code: 0,
            message: 'Success',
            data: response.response
          };
        }
      } catch (parseError) {
        console.error(`Failed to parse response: ${parseError.message}`);
        return {
          success: false,
          code: -2,
          message: `Failed to parse response: ${parseError.message}`,
          data: null
        };
      }
    } else {
      return this.handleResponseError(response);
    }
  }

  /**
   * 销毁HTTP客户端
   */
  static destroy(): void {
    if (NetworkUtils.HTTP_CLIENT) {
      NetworkUtils.HTTP_CLIENT.destroy();
    }
  }
}