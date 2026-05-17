using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace BL.GSTP.DLQGC06
{
    public class C06_TOAAN_TINHTRANGHONNHAN
    {
        public String LOAI_AN_TEN { get; set; }
        public String LOAIAN_ID { get; set; }
        public String LOAI_BAQD { get; set; }  
        public String MAVUVIEC { get; set; }
        public String TenVuAn { get; set; }
        public String DONID { get; set; }
        public String BAQD_ID { get; set; }
        public String SO_BAN_AN { get; set; }
        public String NGAY_RA_BAN_AN { get; set; }
        public String NGAY_HIEU_LUC_BA { get; set; }
        public String DON_VI_RA_BAN_AN_ID { get; set; }
        public String DON_VI_RA_BAN_AN_TEN { get; set; }
        public String NGAY_NHAN_NGUYEN_DON { get; set; }
        public String NGAY_NHAN_BI_DON { get; set; }
        public String HO_TEN_NGUYEN_DON { get; set; }
        public String GIOI_TINH_NGUYEN_DON { get; set; }
        
        public String SO_GIAY_TO_NGUYEN_DON { get; set; }
        public String SO_CMND_NGUYEN_DON { get; set; }
        
        public String NGAY_SINH_NGUYEN_DON { get; set; }
        public String QUOC_TICH_NGUYEN_DON { get; set; }
        public String HO_TEN_BI_DON { get; set; }
        public String GIOI_TINH_BI_DON { get; set; }

        public String SO_GIAY_TO_BI_DON { get; set; }
        public String SO_CMND_BI_DON { get; set; }

        public String NGAY_SINH_BI_DON { get; set; }
        public String QUOC_TICH_BI_DON { get; set; }
        public String TRANG_THAI_TTHN { get; set; }
        public String trangThaiBanGhi { get; set; }
        public String ghiChu { get; set; }
        public String CAPXX { get; set; }
        public String KHANGCAOQH { get; set; }

        public String TRANG_THAI_DONGBO { get; set; }
        public DateTime NGAYGUI { get; set; }
        public String TAIKHOANGUI { get; set; }
        
        public String STATUS { get; set; }
        public String NGUYENDON_ID { get; set; }
        public String BIDON_ID { get; set; }
        public String THULY { get; set; }
        public String trangThaiXacThucNguyenDon { get; set; }
        public String trangThaiXacThucBiDon { get; set; }
        public String maDinhDanhBanAn { get; set; }

        public String maDonViNhanBanAn { get; set; }

        public String tenDonViNhanBanAn { get; set; }
        public String soGiayCNKH { get; set; }
        public String loaiViec { get; set; }
        

        public C06_TOAAN_TINHTRANGHONNHAN() { }  // bắt buộc phải có

    }
}