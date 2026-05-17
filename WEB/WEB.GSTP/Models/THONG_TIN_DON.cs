using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WEB.GSTP.Models
{
    /* Thông tin đơn dạng danh sách (List<object>) */
    public class THONG_TIN_DON
    {
        /* Guid của đơn */
        public byte[] GUID { get; set; }
        /* Hình thức đơn (1-đơn; 2-công văn; 3-đơn+ công văn) */
        public int HINHTHUCDON { get; set; }
        /* Tên người gửi */
        public string NGUOIGUI { get; set; }
        /* Mã tỉnh nơi cư trú của người gửi đơn */
        public string TINH { get; set; }
        /* Mã Huyện nơi cư trú của người gửi đơn */
        public string HUYEN { get; set; }
        /* Địa chỉ chi tiết nơi cư trú của người gửi đơn */
        public string CHITIET { get; set; }
        /* Giới tính (1-nam; 0-nữ) */
        public int GIOITINH { get; set; }
        /* Ngày sinh "dd-MM-yyyy"*/
        public string NGAYSINH { get; set; }
        /* Ngày nhận đơn "dd-MM-yyyy"*/
        public string NGAYNHANDON { get; set; }
        /* Ngày ghi trên đơn "dd-MM-yyyy"*/
        public string NGAYGHITRENDON { get; set; }
        /* Tư cách tố tụng (NGUYENDON-BIDON-BICAO-BIHAI-KHAC) */
        public string TUCACHTOTUNG { get; set; }
        /* Nội dung đơn */
        public string NOIDUNGDON { get; set; }
        /* Ghi chú */
        public string GHICHU { get; set; }
        /* Kết quả giải quyết (1-có; 2-Không; 3-chưa xác định) */
        public int KETQUAGIAIQUYET { get; set; }
        /* Nội dung kết quả giải quyết nếu có */
        public string NOIDUNGGIAIQUYET { get; set; }
        /* Mã cán bộ chỉ đạo */
        public string CANBOCHIDAO { get; set; }
        /* Nội dung chỉ đạo */
        public string YKIENCHIDAO { get; set; }
        /* Đơn trùng? (1-Là đơn trùng; 0-đơn gốc) */
        public int ISDONTRUNG { get; set; }
        /* Mã của đơn gốc */
        public string MADONTRUNG { get; set; }
        /* Số công văn */
        public string CV_SO { get; set; }
        /* Ngày công văn "dd-MM-yyyy"*/
        public string CV_NGAY { get; set; }
        /* Trong ngành (1-trong ngành; 0-ngoài ngành) */
        public int CV_ISTRONGNGANH { get; set; }
        /* Tên đơn vị/ mã đơn vị gửi công văn */
        public string CV_DONVI { get; set; }
        /* Người ký công văn */
        public string CV_NGUOIKY { get; set; }
        /* Chức vụ người ký */
        public string CV_CHUCVU { get; set; }
        /* Ghi chú công văn */
        public string CV_GHICHU { get; set; }
        /* Mã tỉnh của cơ quan chuyển đơn */
        public string CV_TINH { get; set; }
        /* Mã huyện của cơ quan chuyển đơn */
        public string CV_HUYEN { get; set; }
        /* Mã loại công văn 9.1, 8.3 … */
        public string CV_LOAI { get; set; }
        /* Trại Giam? (1-đơn vị gửi là trại giam) */
        public int CV_ISTRAIGIAM { get; set; }
        /* Yêu cầu thông báo? (1-có; 0-không) */
        public int YEUCAUTHONGBAO { get; set; }
        /* Đồng khiếu nại */
        public List<DONGKHIEUNAI> DONGKHIEUNAIs { get; set; }
        /* Kết quả giải quyết đơn: 1-Trả lời đơn; 2-Kháng nghị; 3-Xếp đơn; 4-Xử lý khác) */
        public int GIAIQUYETDON { get; set; }
        /* Loại văn bản bị đề nghị giám đốc thẩm: 0-Bản án; 2-Quyết định */
        public int BAQD_LOAI { get; set; }
        /* Số bản án/ quyết định */
        public string BAQD_SO { get; set; }
        /* Ngày bản án/quyết định "dd-MM-yyyy"*/
        public string BAQD_NGAY { get; set; }
        /* Mã tòa án đưa ra bản án/ quyết định */
        public string BAQD_TOAAN { get; set; }
    }
}