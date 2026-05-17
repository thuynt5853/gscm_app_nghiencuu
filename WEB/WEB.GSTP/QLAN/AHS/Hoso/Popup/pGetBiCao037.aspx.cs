using BL.GSTP;
using BL.GSTP.AHN;
using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Module.Common.C06;

namespace WEB.GSTP.QLAN.AHN.Hoso.Popup
{
    /* - GTEL-Phạm Đức
       - Mở popup thông tin bị can khi lấy dữ liệu từ API 037 tương tự logic của án Hôn Nhân
       - 17-09-2025 10h:00  */
    public partial class pGetBiCao037 : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        public decimal DonID = 0, DuongSuID = 0;
        private const decimal ROOT = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["CongDan"] != null)
                {
                    CongDan037 cd = (CongDan037)Session["CongDan"];

                    lblHoTen.Text = cd.HoVaTen.Ten.ToString();
                    DateTime ngaythang;
                    if (cd.NgayThangNam != null)
                    {
                        ngaythang = DateTime.ParseExact(cd.NgayThangNam, "yyyyMMdd", System.Globalization.CultureInfo.InvariantCulture);
                        lblNgaySinh.Text = ngaythang.ToString("dd/MM/yyyy");
                    }
                    else
                    {
                        lblNgaySinh.Text = cd.NamSinh.ToString();
                    }


                    lblCCCD.Text = cd.SoDinhDanh.ToString();
                    lblCMND.Text = cd.SoCMND.ToString();
                    if (cd.GioiTinh == "2")
                    {
                        lblGioiTinh.Text = "Nữ";
                        hdGioiTinhId.Value = "2";
                    }
                    else
                    {
                        lblGioiTinh.Text = "Nam";
                        hdGioiTinhId.Value = "1";
                    }

                    //Noi o hien tai
                    string maTinh = cd.NoiOHienTai.MaTinhThanh;
                    DM_HANHCHINH dmTinh = null;
                    if (maTinh != null)
                    {
                        dmTinh = dt.DM_HANHCHINH.Where(x => x.MA == maTinh && x.SOCAP == 1 && x.HIEULUC == 1).FirstOrDefault();
                        if (dmTinh != null)
                        {
                            hdTinhId.Value = dmTinh.ID.ToString();
                            lblTinh.Text = dmTinh.TEN;
                        }

                    }

                    string maXa = cd.NoiOHienTai.MaPhuongXa;
                    DM_HANHCHINH dmHuyen = null;
                    if (maXa != null)
                    {
                        dmHuyen = dt.DM_HANHCHINH.Where(x => x.MA == maXa && x.SOCAP == 2 && x.HIEULUC == 1).FirstOrDefault();
                        if (dmHuyen != null)
                        {
                            lblHuyen.Text = dmHuyen.TEN;
                            hdXaId.Value = dmHuyen.ID.ToString();
                        }

                    }
                    lblDiaChiChiTiet.Text = cd.NoiOHienTai.ChiTiet.ToString();

                    //Quê quán -- Thay quê quán = Nơi đăng ký khai sinh
                    //string maTinh_QQ = cd.QueQuan.MaTinhThanh;
                    string maTinh_QQ = cd.NoiDangKyKhaiSinh.MaTinhThanh;
                    DM_HANHCHINH dmTinhQQ = null;
                    if (maTinh_QQ != null)
                    {
                        dmTinhQQ = dt.DM_HANHCHINH.Where(x => x.MA == maTinh_QQ && x.SOCAP == 1 && x.HIEULUC == 1).FirstOrDefault();
                        if (dmTinhQQ != null)
                        {
                            lblQueQuanTinh.Text = dmTinhQQ.TEN;
                            hdQueQuanTinhId.Value = dmTinhQQ.ID.ToString();
                        }
                    }

                    //string maXaQQ = cd.QueQuan.MaPhuongXa;
                    string maXaQQ = cd.NoiDangKyKhaiSinh.MaPhuongXa;
                    DM_HANHCHINH dmHuyenQQ = null;
                    if (maXaQQ != null)
                    {
                        dmHuyenQQ = dt.DM_HANHCHINH.Where(x => x.MA == maXaQQ && x.SOCAP == 2 && x.HIEULUC == 1).FirstOrDefault();
                        if (dmHuyenQQ != null)
                        {
                            lblQueQuanXa.Text = dmHuyenQQ.TEN;
                            hdQueQuanXaId.Value = dmHuyenQQ.ID.ToString();
                        }
                    }
                    //lblQueQuanChiTiet.Text = cd.QueQuan.ChiTiet.ToString();
                    lblQueQuanChiTiet.Text = cd.NoiDangKyKhaiSinh.ChiTiet.ToString();
                    //Thường trú
                    string maTinh_TT = cd.ThuongTru.MaTinhThanh;
                    DM_HANHCHINH dmTinhTT = null;
                    if (dmTinhTT != null)
                    {
                        dmTinhTT = dt.DM_HANHCHINH.Where(x => x.MA == maTinh_TT && x.SOCAP == 1 && x.HIEULUC == 1).FirstOrDefault();
                        if (dmTinhTT != null)
                            lblThuongTruTinh.Text = dmTinhTT.TEN;
                    }


                    string maXaTT = cd.ThuongTru.MaPhuongXa;
                    DM_HANHCHINH dmHuyenTT = null;
                    if (dmHuyenTT != null)
                    {
                        dmHuyenTT = dt.DM_HANHCHINH.Where(x => x.MA == maXaTT && x.SOCAP == 2 && x.HIEULUC == 1).FirstOrDefault();
                        if (dmHuyenTT != null)
                            lblThuongTruXa.Text = dmHuyenTT.TEN;
                    }
                    lblThuongTruChiTiet.Text = cd.ThuongTru.ChiTiet.ToString();
                    //Thông tin cha/me/vc
                    lblHoTenCha.Text = cd.Cha.HoVaTen.Ten;
                    lblHoTenMe.Text = cd.Me.HoVaTen.Ten;
                    lblHoTenVoChong.Text = cd.VoChong.HoVaTen.Ten;

                }

            }
        }

        protected void btnLayThongTin_Click(object sender, EventArgs e)
        {
            //Khoi tao doi tuong sẽ lay thong tin
            CongDan037 CongDanLay = new CongDan037();

            if (chkHoTen.Checked)
            {
                CongDanLay.HoVaTen.Ten = lblHoTen.Text;
            }

            if (chkCMND.Checked)
            {
                CongDanLay.SoCMND = lblCMND.Text;
            }
            if (chkNgaySinh.Checked)
            {
                CongDanLay.NgayThangNam = lblNgaySinh.Text;
            }

            if (chkGioiTinh.Checked)
            {
                CongDanLay.GioiTinh = hdGioiTinhId.Value;
            }
            //Noi cu tru
            if (chkDiaChiChiTiet.Checked)
            {
                CongDanLay.NoiOHienTai.ChiTiet = lblDiaChiChiTiet.Text;
            }
            if (chkDiaChiTinh.Checked)
            {
                CongDanLay.NoiOHienTai.MaTinhThanh = hdTinhId.Value;
                //CongDanLay.NoiOHienTai.MaPhuongXa = hdXaId.Value;
            }
            if (chkDiaChiXa.Checked)
            {
                //CongDanLay.NoiOHienTai.MaTinhThanh = hdTinhId.Value;
                CongDanLay.NoiOHienTai.MaPhuongXa = hdXaId.Value;
            }
            //Que quan
            if (chkQueQuanChiTiet.Checked)
            {
                CongDanLay.QueQuan.ChiTiet = lblDiaChiChiTiet.Text;
            }
            if (chkQueQuanTinh.Checked)
            {
                CongDanLay.QueQuan.MaTinhThanh = hdQueQuanTinhId.Value;
                //CongDanLay.QueQuan.MaPhuongXa = hdQueQuanXaId.Value;
            }
            if (chkQueQuanXa.Checked)
            {
                //CongDanLay.QueQuan.MaTinhThanh = hdQueQuanTinhId.Value;
                CongDanLay.QueQuan.MaPhuongXa = hdQueQuanXaId.Value;
            }
            //Nguoi Than
            if (chkHoTenCha.Checked)
            {
                CongDanLay.Cha.HoVaTen.Ten = lblHoTenCha.Text;
            }
            if (chkHoTenMe.Checked)
            {
                CongDanLay.Me.HoVaTen.Ten = lblHoTenMe.Text;
            }
            if (chkHoTenVoChong.Checked)
            {
                CongDanLay.VoChong.HoVaTen.Ten = lblHoTenVoChong.Text;
            }

            // Escape dữ liệu để tránh lỗi khi chèn vào JavaScript
            string hovaten = HttpUtility.JavaScriptStringEncode(CongDanLay.HoVaTen?.Ten ?? "");
            string cmnd = HttpUtility.JavaScriptStringEncode(CongDanLay.SoCMND ?? "");
            string gioiTinh = HttpUtility.JavaScriptStringEncode(CongDanLay.GioiTinh.Trim() ?? "");
            string namsinh = HttpUtility.JavaScriptStringEncode(CongDanLay.NgayThangNam ?? "");
            string diachiTinh = HttpUtility.JavaScriptStringEncode(CongDanLay.NoiOHienTai.MaTinhThanh ?? "");
            string diachiXa = HttpUtility.JavaScriptStringEncode(CongDanLay.NoiOHienTai.MaPhuongXa ?? "");
            string diachiChiTiet = HttpUtility.JavaScriptStringEncode(CongDanLay.NoiOHienTai?.ChiTiet ?? "");
            string diachiQueQuanTinh = HttpUtility.JavaScriptStringEncode(CongDanLay.QueQuan.MaTinhThanh ?? "");
            string diachiQueQuanXa = HttpUtility.JavaScriptStringEncode(CongDanLay.QueQuan.MaPhuongXa ?? "");
            string diachiQueQuanChiTiet = HttpUtility.JavaScriptStringEncode(CongDanLay.QueQuan?.ChiTiet ?? "");
            string hovatenCha = HttpUtility.JavaScriptStringEncode(CongDanLay.Cha.HoVaTen?.Ten ?? "");
            string hovatenMe = HttpUtility.JavaScriptStringEncode(CongDanLay.Me.HoVaTen?.Ten ?? "");
            string hovatenVoChong = HttpUtility.JavaScriptStringEncode(CongDanLay.VoChong.HoVaTen?.Ten ?? "");
            //string caller = Request.QueryString["caller"] ?? "";
            string script = $@"
                            <script type='text/javascript'>
                                try {{
                                    if (window.opener && !window.opener.closed) {{

                                        function setTextbox(id, val) {{
                                            if (val && val.trim() !== '') {{
                                                var txt = window.opener.document.getElementById(id);
                                                if (txt){{
                                                    txt.value = val;
                                                    txt.setAttribute('readonly', 'readonly');
                                                }}
                                            }}
                                        }}

                                        function setDropdown(id, val) {{
                                            if (val && val.trim() !== '') {{
                                                var ddl = window.opener.document.getElementById(id);
                                                if (ddl) {{
                                                    ddl.value = val;
                                                    if (window.opener.$) {{
                                                        //window.opener.$('#' + id).trigger('chosen:updated');
                                                         window.opener.$('#' + id).trigger('change').trigger('chosen:updated');
                                                    }}
                                                }}
                                            }}
                                        }}
                                        
                                        setTextbox('txtTen', '{hovaten}');
                                        setTextbox('txtNgaysinh', '{namsinh}');
                                        
                                        setTextbox('txtCMND', '{cmnd}');
                                        
                                        setDropdown('ddlGioitinh', '{gioiTinh}');
                                        
                                        // Set tỉnh
                                         setDropdown('ddlTamTru_Tinh', '{diachiTinh}');
                                         var hid = window.opener.document.getElementById('hdTamTruXaId');
                                            if(hid) hid.value = '{diachiXa}';
                                            // Gọi postback để load huyện từ server
                                           if (window.opener.__doPostBack) {{
                                                window.opener.__doPostBack('ddlTamTru_Tinh', '');
                                            }}
                                           
                                          setTextbox('txtTamtru_Chitiet', '{diachiChiTiet}');
                                         // set thong tin que quan/noi sinh
                                         // Set tỉnh
                                         setDropdown('ddlHKTT_Tinh', '{diachiQueQuanTinh}');
                                        
                                            // Gọi postback để load huyện từ server
                                           if (window.opener.__doPostBack) {{
                                                window.opener.__doPostBack('ddlHKTT_Tinh', '');
                                            }}
                                          //set xã
                                          var hidqq = window.opener.document.getElementById('hdNoiSinhXaId');
                                            if(hidqq) hidqq.value = '{diachiQueQuanXa}';
                                          
                                          setTextbox('txtHKTT_Chitiet', '{diachiQueQuanChiTiet}');
                                          
                                          //Thông tin nhân thân
                                          setTextbox('txtBo_HoTen', '{hovatenCha}');
                                        var hidHoTenCha = window.opener.document.getElementById('hdHoTenCha');
                                            if(hidHoTenCha) hidHoTenCha.value = '{hovatenCha}';
                                            // gọi postback để set giá trị
                                            window.opener.__doPostBack('txtBo_HoTen', '');
                                        setTextbox('txtMe_HoTen', '{hovatenMe}');
                                           window.opener.__doPostBack('txtMe_HoTen', '');
                                          var hidHoTenMe = window.opener.document.getElementById('hdHoTenMe');
                                            if(hidHoTenMe) hidHoTenMe.value = '{hovatenMe}';

                                        setTextbox('txtBanDoi_HoTen', '{hovatenVoChong}');
                                           window.opener.__doPostBack('txtBanDoi_HoTen', '');
                                        var hidHoTenVoChong = window.opener.document.getElementById('hdHoTenVoChong');
                                            if(hidHoTenVoChong) hidHoTenVoChong.value = '{hovatenVoChong}';
                                    }} else {{
                                        console.log('Không tìm thấy form chính');
                                    }}
                                }} catch (ex) {{
                                    alert('Lỗi truyền dữ liệu: ' + ex.message);
                                }}
                                window.close();
                            </script>";


            ScriptManager.RegisterStartupScript(this, this.GetType(), "ClosePopup", script, false);


        }
    }
}