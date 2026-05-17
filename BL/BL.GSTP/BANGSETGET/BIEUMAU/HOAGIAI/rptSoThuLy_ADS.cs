using System;

namespace BL.GSTP.BANGSETGET.BIEUMAU.HOAGIAI
{
    public class rptSoThuLy_ADS
    {
        public decimal? STT { get; set; }

        #region THỤ LÝ ĐƠN

        /// <summary>
        /// THỤ LÝ ĐƠN - Ngày, tháng, năm nhận đơn
        /// </summary>
        public DateTime? TLD_NGAY_NHAN_DON { get; set; }

        /// <summary>
        /// THỤ LÝ ĐƠN - Tóm tắt nội dung đơn
        /// </summary>
        public string TLD_NOI_DUNG_TOM_TAT { get; set; }

        /// <summary>
        /// THỤ LÝ ĐƠN - Tài liệu kèm
        /// </summary>
        public string TLD_FILE_DINH_KEM { get; set; }

        #endregion THỤ LÝ ĐƠN

        #region NGƯỜI THAM GIA

        /// <summary>
        /// Người khởi kiên, người yêu cầu, người đại diện (Họ tên; Địa chỉ)
        /// </summary>
        public string NTG_NGUOI_KHOI_KIEN { get; set; }

        /// <summary>
        /// Người bị kiện, người đại diện (Họ tên; Địa chỉ)
        /// </summary>
        public string NTG_NGUOI_BI_KIEN { get; set; }

        /// <summary>
        /// Những người tham gia hòa giải khác (Họ tên; Địa chỉ)
        /// </summary>
        public string NTG_NGUOI_KHAC { get; set; }

        /// <summary>
        /// Thẩm phán phụ trách hòa giải (Họ tên)
        /// </summary>
        public string NTG_THAMPHAN { get; set; }

        /// <summary>
        /// Do Thẩm phán chỉ định (Họ tên)
        /// </summary>
        public string NTG_HGV_TPCHIDINH { get; set; }

        /// <summary>
        /// Do đương sự lựa chọn (Họ tên; TAND nơi quản lý Hòa giải viên)
        /// </summary>
        public string NTG_HGV_DSLUACHON { get; set; }

        #endregion NGƯỜI THAM GIA

        #region THÔNG BÁO VỀ QUYỀN LỰA CHỌN HÒA GIẢI, LỰA CHỌN HÒA GIẢI VIÊN

        /// <summary>
        /// Thông báo về quyền lựa chọn hòa giải, lựa chọn Hòa giải viên (Số; Ngày, tháng, năm)
        /// </summary>
        public string TB_SO_THONG_BAO { get; set; }

        #endregion THÔNG BÁO VỀ QUYỀN LỰA CHỌN HÒA GIẢI, LỰA CHỌN HÒA GIẢI VIÊN

        #region Ý KIẾN CỦA ĐƯƠNG SỰ

        /// <summary>
        /// Đồng ý (Ngày, tháng, năm)
        /// </summary>
        public string YKDS_NBK_DONGY { get; set; }

        /// <summary>
        /// Không đồng ý (Ngày, tháng, năm)
        /// </summary>
        public string YKDS_NBK_KDONGY { get; set; }

        /// <summary>
        /// Đồng ý (Ngày, tháng, năm)
        /// </summary>
        public string YKDS_NKK_DONGY { get; set; }

        /// <summary>
        /// Không đồng ý (Ngày, tháng, năm)
        /// </summary>
        public string YKDS_NKK_KDONGY { get; set; }

        /// <summary>
        /// Không trả lời thông báo lần 02 (Ngày, tháng, năm hết hạn thông báo)
        /// </summary>
        public string YKDS_NKK_KTRALOI { get; set; }

        #endregion Ý KIẾN CỦA ĐƯƠNG SỰ

        #region KẾT QUẢ HÒA GIẢI

        #region Phiên họp ghi nhận kết quả hòa giải

        /// <summary>
        /// Ngày, tháng, năm
        /// </summary>
        public string KQHG_PHGN_NGAY { get; set; }

        /// <summary>
        /// Hòa giải thành (Tóm tắt nội dung)
        /// </summary>
        public string KQHG_PHGN_HGT_NOIDUNG { get; set; }

        /// <summary>
        /// Hòa giải không thành (Tóm tắt nội dung)
        /// </summary>
        public string KQHG_PHGN_HGKT_NOIDUNG { get; set; }

        #endregion Phiên họp ghi nhận kết quả hòa giải

        #region Quyết định của Tòa án

        /// <summary>
        /// Yêu cầu của đương sự (Ngày, tháng, năm; Tóm tắt nội dung yêu cầu)
        /// </summary>
        public string KQHG_QDTA_YCDS { get; set; }

        /// <summary>
        /// Quyết định công nhận kết quả hòa giải thành (Số; Ngày, tháng, năm)
        /// </summary>
        public string KQHG_QDTA_QDCNHGT { get; set; }

        /// <summary>
        /// Quyết định không công nhận kết quả hòa giải thành (Số, ngày, tháng, năm)
        /// </summary>
        public string KQHG_QDTA_QDKCNHGT { get; set; }

        #endregion Quyết định của Tòa án

        #endregion KẾT QUẢ HÒA GIẢI

        #region CHUYỂN ĐƠN GIẢI QUYẾT THEO THỦ TỤC TỐ TỤNG

        /// <summary>
        /// Số; Ngày, tháng, năm
        /// </summary>
        public string CDGQ_SO { get; set; }

        /// <summary>
        /// Lý do chuyển đơn
        /// </summary>
        public string CDGQ_LYDO { get; set; }

        #endregion CHUYỂN ĐƠN GIẢI QUYẾT THEO THỦ TỤC TỐ TỤNG

        #region GIẢI QUYẾT ĐỀ NGHỊ, KIẾN NGHỊ XEM XÉT LẠI QUYẾT ĐỊNH CÔNG NHẬN KẾT QUẢ HÒA GIẢI THÀNH

        /// <summary>
        /// Người đề nghị (Họ tên; Ngày, tháng, năm)
        /// </summary>
        public string KQGQ_NGUOI_DE_NGHI { get; set; }

        /// <summary>
        /// Viện kiểm sát kiến nghị (Số; Ngày tháng, năm)
        /// </summary>
        public string KQGQ_VKS_KIEN_NGHI { get; set; }

        /// <summary>
        /// Chuyển hồ sơ cho Tòa án cấp trên trực tiếp  (Ngày, tháng, năm)
        /// </summary>
        public string KQGQ_CAPTREN { get; set; }

        /// <summary>
        /// Quyết định của Tòa án cấp trên trực tiếp (Số; Ngày tháng, năm; Tóm tắt phần quyết định)
        /// </summary>
        public string KQGQ_CAPTREN_QD { get; set; }

        #endregion GIẢI QUYẾT ĐỀ NGHỊ, KIẾN NGHỊ XEM XÉT LẠI QUYẾT ĐỊNH CÔNG NHẬN KẾT QUẢ HÒA GIẢI THÀNH

        /// <summary>
        /// GHI CHÚ
        /// </summary>
        public string GHICHU { get; set; }
    }
}