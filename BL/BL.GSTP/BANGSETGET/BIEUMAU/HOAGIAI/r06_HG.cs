using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace BL.GSTP.BANGSETGET.BIEUMAU.HOAGIAI
{
    /// <summary>
    /// Hướng dẫn sử dụng mẫu số 06-HG:
    ///(1) Ghi tên Tòa án nhân dân cấp tỉnh của tỉnh đó nếu Tòa án nhân dân ra quyết định là Tòa án nhân dân cấp huyện
    ///(ví dụ: Tòa án nhân dân ra quyết định là Tòa án nhân dân quận Đống Đa, thành phố Hà Nội thì ghi “TÒA ÁN NHÂN DÂN 
    ///THÀNH PHỐ HÀ NỘI”; Ghi “TÒA ÁN NHÂN DÂN TỐI CAO” nếu Tòa án nhân dân ra quyết định là Tòa án nhân dân cấp tỉnh.
    ///(2) và(3) Ghi tên Tòa án nhân dân ra quyết định, nếu là Tòa án nhân dân huyện, quận, thị xã, thành phố thuộc tỉnh 
    ///thì ghi rõ tên Tòa án nhân dân huyện, quận, thị xã, thành phố thuộc tỉnh, thành phố trực thuộc Trung ương nào(ví dụ: 
    ///TÒA ÁN NHÂN DÂN HUYỆN THƯỜNG TÍN); nếu là Tòa án nhân dân tỉnh, thành phố trực thuộc Trung ương thì ghi Tòa án nhân 
    ///dân tỉnh(thành phố) đó(ví dụ: TÒA ÁN NHÂN DÂN TỈNH HÀ NAM).
    ///(4) Trường hợp thay đổi Hòa giải viên theo căn cứ quy định tại Điều 18 của Luật Hòa giải, đối thoại tại Tòa án thì 
    ///bổ sung thêm căn cứ Điều 18.
    ///(5) Ghi quan hệ tranh chấp/yêu cầu mà người khởi kiện/người yêu cầu đề nghị giải quyết.
    ///(6) Ghi tên và địa chỉ của người khởi kiện/người yêu cầu, người bị kiện; nếu là cá nhân thì ghi họ tên, địa chỉ nơi 
    ///cư trú và nơi làm việc; nếu là cơ quan, tổ chức thì ghi tên, địa chỉ của cơ quan, tổ chức.Cần lưu ý đối với cá nhân, 
    ///thì tùy theo độ tuổi mà ghi Ông hoặc Bà, Anh hoặc Chị trước khi ghi họ tên(ví dụ: “Kính gửi: Anh Trần Văn B”).
    ///(7) Tùy từng trường hợp quy định tại Điều 17 Luật Hòa giải, đối thoại tại Tòa án mà ghi cơ sở để ra quyết định chỉ 
    ///định Hòa giải viên là “Xét lựa chọn Hòa giải viên của người khởi kiện/người yêu cầu”, “Xét lựa chọn Hòa giải viên của 
    ///người khởi kiện/người yêu cầu và sự đồng ý của Hòa giải viên được lựa chọn và Tòa án nơi Hòa giải viên đó làm việc”, 
    ///“Xét thỏa thuận lựa chọn Hòa giải viên của các bên”, “Xét việc người khởi kiện/người yêu cầu không lựa chọn Hòa giải 
    ///viên”. Nếu là quyết định thay đổi Hòa giải viên theo sự đề nghị của người bị kiện thì ghi “Xét đề nghị thay đổi Hòa 
    ///giải viên của người bị kiện”.
    ///(8) Ghi tên Tòa án nhân dân nơi Hòa giải viên làm việc theo hướng dẫn tại điểm(2)
    ///(9) Trường hợp thay đổi Hòa giải viên thì ghi thêm cụm từ “và thay thế Quyết định số....ngày.... ”.
    ///(10) Trường hợp thay đổi Hòa giải viên thì gửi quyết định cho Hòa giải viên được chỉ định và cho Hòa giải viên bị thay đổi.

    /// </summary>
    public partial class r06_HG
    {
        public r06_HG()
        {
            this.TOA_CAP_TREN = "                               ";
            this.TOA_HIEN_TAI = "                               ";
            this.SO_QUYET_DINH = "                              ";
            this.DIA_CHI = "                                ";
            this.NGAY = "                               ";
            this.THANG = "                              ";
            this.NAM = "                                ";
            this.THOI_GIAN = "                              ";
            this.TEN_QHPL = "                               ";
            this.NGUOI_KHOI_KIEN = "                                ";
            this.NGUOI_BI_KIEN = "                              ";
            this.TEN_QUYET_DINH = "                             ";
            this.HOA_GIAI_VIEN = "                              ";
            this.TOA_HGV = "                                ";
            this.NGUOI_KY = "                               ";
        }

        /// <summary>
        /// (1) Ghi tên Tòa án nhân dân cấp tỉnh của tỉnh đó nếu Tòa án nhân dân ra quyết định là Tòa án nhân dân cấp 
        /// huyện (ví dụ: Tòa án nhân dân ra quyết định là Tòa án nhân dân quận Đống Đa, thành phố Hà Nội thì ghi “TÒA 
        /// ÁN NHÂN DÂN THÀNH PHỐ HÀ NỘI”; Ghi “TÒA ÁN NHÂN DÂN TỐI CAO” nếu Tòa án nhân dân ra quyết định là Tòa án nhân dân cấp tỉnh.
        /// </summary>
        public String TOA_CAP_TREN { get; set; }

        /// <summary>
        /// (2) và (3) Ghi tên Tòa án nhân dân ra quyết định, nếu là Tòa án nhân dân huyện, quận, thị xã, thành phố 
        /// thuộc tỉnh thì ghi rõ tên Tòa án nhân dân huyện, quận, thị xã, thành phố thuộc tỉnh, thành phố trực thuộc 
        /// Trung ương nào (ví dụ: TÒA ÁN NHÂN DÂN HUYỆN THƯỜNG TÍN); nếu là Tòa án nhân dân tỉnh, thành phố trực thuộc 
        /// Trung ương thì ghi Tòa án nhân dân tỉnh (thành phố) đó (ví dụ: TÒA ÁN NHÂN DÂN TỈNH HÀ NAM).
        /// </summary>
        public String TOA_HIEN_TAI { get; set; }
        public String SO_QUYET_DINH { get; set; }
        public String DIA_CHI { get; set; }
        public String NGAY { get; set; }
        public String THANG { get; set; }
        public String NAM { get; set; }
        public String THOI_GIAN { get; set; }

        /// <summary>
        /// (5) Ghi quan hệ tranh chấp/yêu cầu mà người khởi kiện/người yêu cầu đề nghị giải quyết.
        /// </summary>
        public String TEN_QHPL { get; set; }

        /// <summary>
        /// (6) Ghi tên và địa chỉ của người khởi kiện/người yêu cầu, người bị kiện; nếu là cá nhân 
        /// thì ghi họ tên, địa chỉ nơi cư trú và nơi làm việc; nếu là cơ quan, tổ chức thì ghi tên, 
        /// địa chỉ của cơ quan, tổ chức. Cần lưu ý đối với cá nhân, thì tùy theo độ tuổi mà ghi Ông 
        /// hoặc Bà, Anh hoặc Chị trước khi ghi họ tên (ví dụ: “Kính gửi: Anh Trần Văn B”).
        /// </summary>
        public String NGUOI_KHOI_KIEN { get; set; }
        public String NGUOI_BI_KIEN { get; set; }

        /// <summary>
        /// (7) Tùy từng trường hợp quy định tại Điều 17 Luật Hòa giải, đối thoại tại Tòa án mà ghi 
        /// cơ sở để ra quyết định chỉ định Hòa giải viên là “Xét lựa chọn Hòa giải viên của người 
        /// khởi kiện/người yêu cầu”, “Xét lựa chọn Hòa giải viên của người khởi kiện/người yêu cầu 
        /// và sự đồng ý của Hòa giải viên được lựa chọn và Tòa án nơi Hòa giải viên đó làm việc”, 
        /// “Xét thỏa thuận lựa chọn Hòa giải viên của các bên”, “Xét việc người khởi kiện/người yêu 
        /// cầu không lựa chọn Hòa giải viên”. Nếu là quyết định thay đổi Hòa giải viên theo sự đề nghị 
        /// của người bị kiện thì ghi “Xét đề nghị thay đổi Hòa giải viên của người bị kiện”.
        /// </summary>
        public String TEN_QUYET_DINH { get; set; }
        public String HOA_GIAI_VIEN { get; set; }

        /// <summary>
        /// (8) Ghi tên Tòa án nhân dân nơi Hòa giải viên làm việc theo hướng dẫn tại điểm (2)
        /// </summary>
        public String TOA_HGV { get; set; }
        public String NGUOI_KY { get; set; }
    }
}