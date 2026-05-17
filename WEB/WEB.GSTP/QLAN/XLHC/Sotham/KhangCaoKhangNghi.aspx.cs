using BL.GSTP;
using DAL.GSTP;
using Module.Common;
using NLog;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.QLAN.XLHC.Sotham
{
    public partial class KhangCaoKhangNghi : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        private const decimal KHIEUNAI = 1, KIENNGHI = 2, KHANGNGHI = 3;
        private Logger logger = NLog.LogManager.GetCurrentClassLogger();

        private const string VIEWSTATE_MAP_QD_TYPE = "MapSoQDToType";
        private Dictionary<string, int> GetMapSoQDToType()
        {
            if (ViewState[VIEWSTATE_MAP_QD_TYPE] == null)
            {
                ViewState[VIEWSTATE_MAP_QD_TYPE] = new Dictionary<string, int>();
            }
            return (Dictionary<string, int>)ViewState[VIEWSTATE_MAP_QD_TYPE];
        }

        private void SetMapSoQDToType(Dictionary<string, int> map)
        {
            ViewState[VIEWSTATE_MAP_QD_TYPE] = map;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    string current_id = Session[ENUM_LOAIAN.BPXLHC] + "";
                    if (current_id == "") Response.Redirect(Cls_Comon.GetRootURL() + "/QLAN/XLHC/Hoso/Danhsach.aspx");
                    decimal ID = Convert.ToDecimal(current_id);
                    LoadComboboxKhieuNai();
                    CheckQuyen(ID);
                    LoadGrid();
                    //KiemTraDonXL();
                }
            }
            catch (Exception ex) 
            {
                lbthongbao.Text = ENUM_MESSAGE.SERVER_ERROR;
                logger.Error("[toaanid={} donid={}] loi xay ra: {}", Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), Convert.ToDecimal(Session[ENUM_LOAIAN.BPXLHC]), ex);
            }
            
        }
        private void CheckQuyen(decimal ID)
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            Cls_Comon.SetButton(btnUpdate, oPer.CAPNHAT);
            Cls_Comon.SetButton(btnLammoi, oPer.CAPNHAT);

            XLHC_DON oT = dt.XLHC_DON.Where(x => x.ID == ID).FirstOrDefault();
            if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.THULYGDT)
            {
                lbthongbao.Text = "Vụ việc đã được chuyển lên tòa cấp trên, không được sửa đổi!";
                Cls_Comon.SetButton(btnUpdate, false);
                Cls_Comon.SetButton(btnLammoi, false);
                hddShowCommand.Value = "False";
                return;
            }
            List<XLHC_SOTHAM_THULY> lstCount = dt.XLHC_SOTHAM_THULY.Where(x => x.DONID == ID).ToList();
            if (lstCount.Count == 0)
            {
                lbthongbao.Text = "Chưa cập nhật thông tin thụ lý sơ thẩm!";
                Cls_Comon.SetButton(btnUpdate, false);
                Cls_Comon.SetButton(btnLammoi, false);
                hddShowCommand.Value = "False";
                return;
            }
            List<XLHC_DON_THAMPHAN> lstTP = dt.XLHC_DON_THAMPHAN.Where(x => x.DONID == ID && x.MAVAITRO == ENUM_VAITROTHAMPHAN.VTTP_GIAIQUYETSOTHAM).ToList();
            if (lstTP.Count == 0)
            {
                lbthongbao.Text = "Chưa phân công thẩm phán giải quyết!";
                Cls_Comon.SetButton(btnUpdate, false);
                Cls_Comon.SetButton(btnLammoi, false);
                hddShowCommand.Value = "False";
                return;
            }
            //XLHC_SOTHAM_KHANGCAO kc = dt.XLHC_SOTHAM_KHANGCAO.Where(x => x.DONID == ID && x.GQ_TINHTRANG == 3).FirstOrDefault();
            //if (kc != null)
            //{
            //    lbthongbao.Text = "KN đã được xử lý phúc thẩm. Vui lòng xoá để thêm thông tin mới";
            //    Cls_Comon.SetButton(btnUpdate, false);
            //    Cls_Comon.SetButton(btnLammoi, false);
            //    return;
            //}
            string StrMsg = "Không được sửa đổi thông tin.";
            string Result = new XLHC_CHUYEN_NHAN_AN_BL().Check_NhanAn_V2(ID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
            if (Result != "")
            {
                lbthongbao.Text = Result;
                Cls_Comon.SetButton(btnUpdate, false);
                Cls_Comon.SetButton(btnLammoi, false);
                hddShowCommand.Value = "False";
                return;
            }
        }
        protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView rowView = (DataRowView)e.Item.DataItem;
                LinkButton lblSua = (LinkButton)e.Item.FindControl("lblSua");
                Cls_Comon.SetLinkButton(lblSua, oPer.CAPNHAT);
                LinkButton lbtXoa = (LinkButton)e.Item.FindControl("lbtXoa");
                Cls_Comon.SetLinkButton(lbtXoa, oPer.XOA);
                string current_id = Session[ENUM_LOAIAN.BPXLHC] + "";
                decimal DONID = Convert.ToDecimal(current_id);


                //// án chuyển đi rồi thì không hiển thị
                //var donXL = dt.XLHC_CHUYEN_NHAN_AN.FirstOrDefault(x => x.VUANID == DONID);

                //if (donXL != null)
                //{
                //    lblSua.Visible = false;
                //    lbtXoa.Visible = false;
                //    lbthongbao.Text = "Vụ việc đã được chuyển lên tòa cấp trên, không được sửa đổi!";
                //}



                XLHC_DON oT = dt.XLHC_DON.Where(x => x.ID == DONID).FirstOrDefault();
                if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.THULYGDT)
                {
                    lblSua.Text = "Chi tiết";
                    lbtXoa.Visible = false;
                }
                if (hddShowCommand.Value == "False")
                {
                    lblSua.Text = "Chi tiết";
                    lbtXoa.Visible = false;
                }
                ImageButton lblDownload = (ImageButton)e.Item.FindControl("lblDownload");
                if (rowView["TENFILE"] + "" != "")
                {
                    lblDownload.Visible = true;
                }
                else
                {
                    lblDownload.Visible = false;
                }

                Decimal idKCKN = Convert.ToDecimal(rowView["ID"]);
                XLHC_SOTHAM_KHANGCAO kc = dt.XLHC_SOTHAM_KHANGCAO.Where(x => x.ID == idKCKN).FirstOrDefault();
                if (kc != null)
                {
                    if (kc.GQ_TINHTRANG == 3)
                    {
                        lblSua.Visible = lbtXoa.Visible = false;
                        return;
                    }
                }
                string toagiaiquyetID = e.Item.Cells[12].Text.Trim();
                string donviID = Session[ENUM_SESSION.SESSION_DONVIID]?.ToString();
                if (toagiaiquyetID != donviID)
                {
                    lbtXoa.Visible = false;
                    lblSua.Visible = false;
                }
            }
        }
        #region Kháng cáo
        private void LoadComboboxKhieuNai()
        {
            decimal DonID = Convert.ToDecimal(Session[ENUM_LOAIAN.BPXLHC] + "");

            //List<XLHC_DON_THAMGIATOTUNG> listNguoiTT = dt.XLHC_DON_THAMGIATOTUNG
            //                                                    .Where(x => x.DONID == DonID)
            //                                                    .ToList();


            XLHC_SOTHAM_BL oBL = new XLHC_SOTHAM_BL();

            DataTable listNguoiTT = oBL.SP_GET_NGUOITHAMGIA_TT(DonID);

            List<XLHC_DUONGSU> listNguoiBiDeNghi = dt.XLHC_DUONGSU
                                                               .Where(x => x.DONID == DonID && x.LOAIDOITUONG == 1)
                                                               .ToList();

            ddlNguoikhangcao.Items.Clear();
            try
            {
                foreach (DataRow row in listNguoiTT.Rows)
                {
                    string ten = row["HOTEN"].ToString();
                    string id = row["ID"].ToString();
                    ddlNguoikhangcao.Items.Add(new ListItem(ten, id));
                }
            }
            catch (Exception ex1)
            {
                System.Diagnostics.Debug.WriteLine("Lỗi khi lấy dữ liệu XLHC_DON_THAMGIATOTUNG: " + ex1.Message);
            }

            try
            {
                foreach (var item in listNguoiBiDeNghi)
                {
                    ddlNguoikhangcao.Items.Add(new ListItem(item.HOTEN + " - " + "Người bị đề nghị", item.ID.ToString()));
                }
            }
            catch (Exception ex1)
            {
                System.Diagnostics.Debug.WriteLine("Lỗi khi lấy dữ liệu XLHC_DUONGSU: " + ex1.Message);
            }


            ddlNguoikhangcao.Items.Insert(0, new ListItem("--Chọn--", "-1"));


            LoadQD();
        }
        private void LoadComboboxKienNghi()
        {
            decimal DonID = Convert.ToDecimal(Session[ENUM_LOAIAN.BPXLHC] + "");

            // Kiểu cụ thể thay cho var
            List<XLHC_DON> listND = dt.XLHC_DON.Where(x => x.ID == DonID).ToList();

            // Xóa dữ liệu cũ
            ddlNguoikhangcao.Items.Clear();
            ddlNguoiKienNghi.Items.Clear();
            ddlNguoiKhangNghi.Items.Clear();

            // Thêm người tham gia vào combobox
            foreach (XLHC_DON nd in listND)
            {
                ddlNguoiKienNghi.Items.Add(new ListItem(nd.CQDN_TEN, nd.ID.ToString()));
            }

            // Thêm dòng "--Chọn--" ở đầu
            ddlNguoiKienNghi.Items.Insert(0, new ListItem("--Chọn--", "-1"));
            LoadQD();

        }
        private void LoadComboboxKhangNghi()
        {
            // Lấy ID người dùng từ session
            decimal userId = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");

            // Gọi BL để lấy danh sách tên người kháng nghị
            XLHC_SOTHAM_BL oBL = new XLHC_SOTHAM_BL();

            QT_NGUOISUDUNG user = dt.QT_NGUOISUDUNG.Where(x => x.ID == userId).FirstOrDefault();

            DataTable oDT;
            decimal donviId;
            if (user.NHOMNSDID == 1) // admin
            {
                donviId = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID] + "");
                oDT = oBL.XLHC_SOTHAM_GETNAME_KHANGNGHI_ADMIN(donviId);
            }
            else
            {
                donviId = userId;
                oDT = oBL.XLHC_SOTHAM_GETNAME_KHANGNGHI(donviId);
            }

            // Xóa dữ liệu cũ của dropdown
            ddlNguoikhangcao.Items.Clear();
            ddlNguoiKienNghi.Items.Clear();
            ddlNguoiKhangNghi.Items.Clear();

            // Kiểm tra dữ liệu trả về có hợp lệ không
            if (oDT != null && oDT.Rows.Count > 0)
            {
                foreach (DataRow row in oDT.Rows)
                {
                    string tenNguoi = row["TEN_VKS"].ToString();
                    string idNguoi = row["VKSID"].ToString();
                    ddlNguoiKhangNghi.Items.Add(new ListItem(tenNguoi, idNguoi));
                }
            }
            // Thêm dòng "--Chọn--" ở đầu danh sách
            ddlNguoiKhangNghi.Items.Insert(0, new ListItem("--Chọn--", "-1"));

            // Gọi hàm load tiếp theo (nếu có)
            LoadQD();
        }

       
        private void LoadQD_BA_InfoKhangCao()
        {
            if (ddlSOQDBA_KC.SelectedValue == "0")
                return;
            decimal ID = Convert.ToDecimal(ddlSOQDBA_KC.SelectedValue);
            decimal DonID = 0;
            if (Session[ENUM_LOAIAN.BPXLHC] != null)
            {
                decimal.TryParse(Session[ENUM_LOAIAN.BPXLHC].ToString(), out DonID);
            }

            // Kiểm tra trong bảng XLHC_SOTHAM_BANAN trước
            XLHC_SOTHAM_BANAN SoThamQD = dt.XLHC_SOTHAM_BANAN.Where(x => x.QUYETDINHID == ID && x.DONID == DonID).FirstOrDefault();
            if (SoThamQD != null)
            {
                txtNgayQDBA_KC.Text = string.IsNullOrEmpty(SoThamQD.NGAYTUYENAN + "") ? "" : ((DateTime)SoThamQD.NGAYTUYENAN).ToString("dd/MM/yyyy", cul);
            }
            else
            {
                // Kiểm tra trong bảng XLHC_SOTHAM_QUYETDINH (từ màn QuyetdinhVuviec)
                XLHC_SOTHAM_QUYETDINH soThamQuyetDinh = dt.XLHC_SOTHAM_QUYETDINH.Where(x => x.QUYETDINHID == ID && x.DONID == DonID).FirstOrDefault();
                if (soThamQuyetDinh != null)
                {
                    txtNgayQDBA_KC.Text = string.IsNullOrEmpty(soThamQuyetDinh.NGAYQD + "") ? "" : ((DateTime)soThamQuyetDinh.NGAYQD).ToString("dd/MM/yyyy", cul);
                }
                else
                {
                    XLHC_DONXIN_HOAN_MIEN SoQD6 = dt.XLHC_DONXIN_HOAN_MIEN.Where(x => x.DM_QUYETDINH_ID == ID && x.DONID == DonID).FirstOrDefault();
                    if (SoQD6 != null)
                    {
                        txtNgayQDBA_KC.Text = string.IsNullOrEmpty(SoQD6.NGAY_QUYETDINH + "") ? "" : ((DateTime)SoQD6.NGAY_QUYETDINH).ToString("dd/MM/yyyy", cul);
                    }
                    else
                    {
                        var soQD3_2 = (from dqq in dt.DM_QD_QUYETDINH
                                       join xsq in dt.XLHC_SOTHAM_QUYETDINH on dqq.ID equals xsq.QUYETDINHID
                                       where xsq.DONID == DonID
                                            && dqq.ISSOTHAM == 1
                                             && dqq.KET_THUC == 0
                                             && dqq.ID == 463

                                       select new
                                       {
                                           dqq.TEN,
                                           dqq.MA,
                                           dqq.ID,
                                           xsq.NGAYQD
                                       }).FirstOrDefault();

                        if (soQD3_2 != null)
                        {
                            txtNgayQDBA_KC.Text = string.IsNullOrEmpty(soQD3_2.NGAYQD + "") ? "" : ((DateTime)soQD3_2.NGAYQD).ToString("dd/MM/yyyy", cul);
                        }
                    }
                }
            }
            
            decimal DonIDID = Convert.ToDecimal(Session[ENUM_LOAIAN.BPXLHC] + "");
            XLHC_DON oDon = dt.XLHC_DON.Where(x => x.ID == DonIDID).FirstOrDefault();
            if (oDon != null)
            {
                DM_TOAAN oToaAn = dt.DM_TOAAN.Where(x => x.ID == oDon.TOAANID).FirstOrDefault();
                if (oToaAn != null)
                {
                    txtToaAnQD_KC.Text = oToaAn.TEN;
                }
                else
                {
                    txtToaAnQD_KC.Text = "";
                }
            }
            else
            {
                txtToaAnQD_KC.Text = "";
            }
        }


        private void LoadQD_BA_InfoKienNghi()
        {
            if (ddlSOQDBA_KienNghi.SelectedValue == "0") return;
            decimal ID = Convert.ToDecimal(ddlSOQDBA_KienNghi.SelectedValue);
            decimal DonID = 0;
            if (Session[ENUM_LOAIAN.BPXLHC] != null)
            {
                decimal.TryParse(Session[ENUM_LOAIAN.BPXLHC].ToString(), out DonID);
            }
            
            XLHC_SOTHAM_BANAN SoThamQD = dt.XLHC_SOTHAM_BANAN.Where(x => x.QUYETDINHID == ID && x.DONID == DonID).FirstOrDefault();
            if (SoThamQD != null)
            {
                txtNgayQDBA_KienNghi.Text = string.IsNullOrEmpty(SoThamQD.NGAYTUYENAN + "") ? "" : ((DateTime)SoThamQD.NGAYTUYENAN).ToString("dd/MM/yyyy", cul);
            }
            else
            {
                // Kiểm tra trong bảng XLHC_SOTHAM_QUYETDINH (từ màn QuyetdinhVuviec)
                XLHC_SOTHAM_QUYETDINH soThamQuyetDinh = dt.XLHC_SOTHAM_QUYETDINH.Where(x => x.QUYETDINHID == ID && x.DONID == DonID).FirstOrDefault();
                if (soThamQuyetDinh != null)
                {
                    txtNgayQDBA_KienNghi.Text = string.IsNullOrEmpty(soThamQuyetDinh.NGAYQD + "") ? "" : ((DateTime)soThamQuyetDinh.NGAYQD).ToString("dd/MM/yyyy", cul);
                }
                else
                {
                    XLHC_DONXIN_HOAN_MIEN SoQD6 = dt.XLHC_DONXIN_HOAN_MIEN.Where(x => x.DM_QUYETDINH_ID == ID && x.DONID == DonID).FirstOrDefault();
                    if (SoQD6 != null)
                    {
                        txtNgayQDBA_KienNghi.Text = string.IsNullOrEmpty(SoQD6.NGAY_QUYETDINH + "") ? "" : ((DateTime)SoQD6.NGAY_QUYETDINH).ToString("dd/MM/yyyy", cul);
                    }
                    else
                    {
                        var soQD3_2 = (from dqq in dt.DM_QD_QUYETDINH
                                       join xsq in dt.XLHC_SOTHAM_QUYETDINH on dqq.ID equals xsq.QUYETDINHID
                                       where xsq.DONID == DonID
                                             && dqq.ISSOTHAM == 1
                                             && dqq.KET_THUC == 0
                                             && dqq.ID == 463
                                       select new
                                       {
                                           dqq.TEN,
                                           dqq.MA,
                                           dqq.ID,
                                           xsq.NGAYQD
                                       }).FirstOrDefault();

                        if (soQD3_2 != null)
                        {
                            txtNgayQDBA_KienNghi.Text = string.IsNullOrEmpty(soQD3_2.NGAYQD + "") ? "" : ((DateTime)soQD3_2.NGAYQD).ToString("dd/MM/yyyy", cul);
                        }
                    }
                }
            }
            
            decimal DonIDID = Convert.ToDecimal(Session[ENUM_LOAIAN.BPXLHC] + "");
            XLHC_DON oDon = dt.XLHC_DON.Where(x => x.ID == DonIDID).FirstOrDefault();
            if (oDon != null)
            {
                DM_TOAAN oToaAn = dt.DM_TOAAN.Where(x => x.ID == oDon.TOAANID).FirstOrDefault();
                if (oToaAn != null)
                {
                    txtToaAnQD_KienNghi.Text = oToaAn.TEN;
                }
                else
                {
                    txtToaAnQD_KienNghi.Text = "";
                }
            }
            else
            {
                txtToaAnQD_KienNghi.Text = "";
            }
        }
        private void LoadQD_BA_InfoKhangNghi()
        {
            if (ddlSOQDBA_KhangNghi.SelectedValue == "0") return;
            decimal ID = Convert.ToDecimal(ddlSOQDBA_KhangNghi.SelectedValue);
            decimal DonID = 0;
            if (Session[ENUM_LOAIAN.BPXLHC] != null)
            {
                decimal.TryParse(Session[ENUM_LOAIAN.BPXLHC].ToString(), out DonID);
            }
            
            XLHC_SOTHAM_BANAN SoThamQD = dt.XLHC_SOTHAM_BANAN.Where(x => x.QUYETDINHID == ID && x.DONID == DonID).FirstOrDefault();
            if (SoThamQD != null)
            {
                txtNgayQDBA_KhangNghi.Text = string.IsNullOrEmpty(SoThamQD.NGAYTUYENAN + "") ? "" : ((DateTime)SoThamQD.NGAYTUYENAN).ToString("dd/MM/yyyy", cul);
            }
            else
            {
                // Kiểm tra trong bảng XLHC_SOTHAM_QUYETDINH (từ màn QuyetdinhVuviec)
                XLHC_SOTHAM_QUYETDINH soThamQuyetDinh = dt.XLHC_SOTHAM_QUYETDINH.Where(x => x.QUYETDINHID == ID && x.DONID == DonID).FirstOrDefault();
                if (soThamQuyetDinh != null)
                {
                    txtNgayQDBA_KhangNghi.Text = string.IsNullOrEmpty(soThamQuyetDinh.NGAYQD + "") ? "" : ((DateTime)soThamQuyetDinh.NGAYQD).ToString("dd/MM/yyyy", cul);
                }
                else
                {
                    XLHC_DONXIN_HOAN_MIEN SoQD6 = dt.XLHC_DONXIN_HOAN_MIEN.Where(x => x.DM_QUYETDINH_ID == ID && x.DONID == DonID).FirstOrDefault();
                    if (SoQD6 != null)
                    {
                        txtNgayQDBA_KhangNghi.Text = string.IsNullOrEmpty(SoQD6.NGAY_QUYETDINH + "") ? "" : ((DateTime)SoQD6.NGAY_QUYETDINH).ToString("dd/MM/yyyy", cul);
                    }
                    else
                    {
                        var soQD3_2 = (from dqq in dt.DM_QD_QUYETDINH
                                       join xsq in dt.XLHC_SOTHAM_QUYETDINH on dqq.ID equals xsq.QUYETDINHID
                                       where xsq.DONID == DonID
                                             && dqq.ISSOTHAM == 1
                                             && dqq.KET_THUC == 0
                                             && dqq.ID == 463
                                       select new
                                       {
                                           dqq.TEN,
                                           dqq.MA,
                                           dqq.ID,
                                           xsq.NGAYQD
                                       }).FirstOrDefault();

                        if (soQD3_2 != null)
                        {
                            txtNgayQDBA_KhangNghi.Text = string.IsNullOrEmpty(soQD3_2.NGAYQD + "") ? "" : ((DateTime)soQD3_2.NGAYQD).ToString("dd/MM/yyyy", cul);
                        }
                    }
                }
            }
            
            decimal DonIDID = Convert.ToDecimal(Session[ENUM_LOAIAN.BPXLHC] + "");
            XLHC_DON oDon = dt.XLHC_DON.Where(x => x.ID == DonIDID).FirstOrDefault();
            if (oDon != null)
            {
                DM_TOAAN oToaAn = dt.DM_TOAAN.Where(x => x.ID == oDon.TOAANID).FirstOrDefault();
                if (oToaAn != null)
                {
                    txtToaAnQD_KhangNghi.Text = oToaAn.TEN;
                }
                else
                {
                    txtToaAnQD_KhangNghi.Text = "";
                }
            }
            else
            {
                txtToaAnQD_KhangNghi.Text = "";
            }
        }
        protected void lbtDownloadKhangCao_Click(object sender, EventArgs e)
        {
            decimal ID = Convert.ToDecimal(hddid.Value);
            XLHC_SOTHAM_KHANGCAO oND = dt.XLHC_SOTHAM_KHANGCAO.Where(x => x.ID == ID).FirstOrDefault();
            if (oND.TENFILE != "")
            {
                var cacheKey = Guid.NewGuid().ToString("N");
                Context.Cache.Insert(key: cacheKey, value: oND.NOIDUNGFILE, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download", "window.location='" + Cls_Comon.GetRootURL_HTTPS_CONFIG() + "/DownloadFile.aspx?cacheKey=" + cacheKey + "&FileName=" + oND.TENFILE + "&Extension=" + oND.KIEUFILE + "';", true);
            }
        }
        protected void rdbLoaiKC_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadQD();
            CheckNgayKCQuaHan();
        }
        protected void ddlSOQDBA_KhieuNai_SelectedIndexChanged(object sender, EventArgs e)
        {
            try { LoadQD_BA_InfoKhangCao(); } catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void ddlSOQDBA_KienNghi_SelectedIndexChanged(object sender, EventArgs e)
        {
            try { LoadQD_BA_InfoKienNghi(); } catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void ddlSOQDBA_KhangNghi_SelectedIndexChanged(object sender, EventArgs e)
        {
            try { LoadQD_BA_InfoKienNghi(); } catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void AsyncFileUpLoadKhangCao_UploadedComplete(object sender, AjaxControlToolkit.AsyncFileUploadEventArgs e)
        {
            if (AsyncFileUpLoadKhangCao.HasFile)
            {
                string strFileName = AsyncFileUpLoadKhangCao.FileName;
                string path = Server.MapPath("~/TempUpload/") + strFileName;
                AsyncFileUpLoadKhangCao.SaveAs(path);

                path = path.Replace("\\", "/");
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "filePath", "top.$get(\"" + hddFilePath_KC.ClientID + "\").value = '" + path + "';", true);
            }
        }
        protected void AsyncFileUpLoadKienNghi_UploadedComplete(object sender, AjaxControlToolkit.AsyncFileUploadEventArgs e)
        {
            if (AsyncFileUpLoadKienNghi.HasFile)
            {
                string strFileName = AsyncFileUpLoadKienNghi.FileName;
                string path = Server.MapPath("~/TempUpload/") + strFileName;
                AsyncFileUpLoadKienNghi.SaveAs(path);

                path = path.Replace("\\", "/");
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "filePath", "top.$get(\"" + hddFilePath_KienNghi.ClientID + "\").value = '" + path + "';", true);
            }
        }

        #endregion
        #region Kháng nghị

        protected void lbtDownloadKhangNghi_Click(object sender, EventArgs e)
        {
            decimal ID = Convert.ToDecimal(hddid.Value);
            XLHC_SOTHAM_KHANGNGHI oND = dt.XLHC_SOTHAM_KHANGNGHI.Where(x => x.ID == ID).FirstOrDefault();
            if (oND.TENFILE != "")
            {
                var cacheKey = Guid.NewGuid().ToString("N");
                Context.Cache.Insert(key: cacheKey, value: oND.NOIDUNGFILE, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download", "window.location='" + Cls_Comon.GetRootURL_HTTPS_CONFIG() + "/DownloadFile.aspx?cacheKey=" + cacheKey + "&FileName=" + oND.TENFILE + "&Extension=" + oND.KIEUFILE + "';", true);
            }
        }
        protected void ddlSOQDBAKhangNghi_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadQD_BA_InfoKhangNghi();
        }

        protected void AsyncFileUpLoadKhangNghi_UploadedComplete(object sender, AjaxControlToolkit.AsyncFileUploadEventArgs e)
        {
            if (AsyncFileUpLoadKhangNghi.HasFile)
            {
                string strFileName = AsyncFileUpLoadKhangNghi.FileName;
                string path = Server.MapPath("~/TempUpload/") + strFileName;
                AsyncFileUpLoadKhangNghi.SaveAs(path);

                path = path.Replace("\\", "/");
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "filePath", "top.$get(\"" + hddFilePath_KhangNghi.ClientID + "\").value = '" + path + "';", true);
            }
        }
        #endregion
        private void ResetControls()
        {
            lbthongbao.Text = "";
            rdbPanelKhieuNai.Visible = rdbPanelKhangNghi.Visible = true;
            if (rdbPanelKhieuNai.SelectedValue == KHIEUNAI.ToString())//
            {
                #region Kháng cáo
                rdbHinhThucNhanDon.ClearSelection();
                txtNgayvietdonKC.Text = txtNgaykhangcao.Text = "";
                ddlNguoikhangcao.SelectedIndex = 0;
                rdbQuahan_KC.ClearSelection();
                LoadQD();
                txtNoidungKC.Text = "";
                txtToaAnQD_KC.Text = "";
                txtNgayQDBA_KC.Text = "";
                hddFilePath_KC.Value = "";
                lbtDownloadKhangCao.Visible = false;
                #endregion
            }
            if (rdbPanelKhangNghi.SelectedValue == KIENNGHI.ToString())
            {
                #region Kiến nghị
                rdbHinhThucNhanDonKienNghi.ClearSelection();
                txtNgayvietdonKienNghi.Text = txtNgayKienNghi.Text = "";
                ddlNguoiKienNghi.SelectedIndex = 0;
                rdbQuahan_KienNghi.ClearSelection();
                LoadQD();
                txtNoidungKienNghi.Text = "";
                txtNgayQDBA_KienNghi.Text = "";
                hddFilePath_KienNghi.Value = "";
                txtToaAnQD_KienNghi.Text = "";
                lbtDownloadKienNghi.Visible = false;
                #endregion
            }
            if (rdbPanelKhangNghi.SelectedValue == KHANGNGHI.ToString())
            {
                #region Kháng nghị
                rdbHinhThucNhanDonKhangNghi.ClearSelection();
                txtNgayvietdonKhangNghi.Text = txtNgayKhangNghi.Text = "";
                ddlNguoiKhangNghi.SelectedIndex = 0;
                rdbQuahan_KhangNghi.ClearSelection();
                LoadQD();
                txtNoidungKhangNghi.Text = "";
                hddFilePath_KhangNghi.Value = "";
                txtNgayQDBA_KhangNghi.Text = "";
                txtToaAnQD_KhangNghi.Text = "";
                lbtDownloadKhangNghi.Visible = false;
                #endregion
            }
            hddid.Value = "0";
        }
        public void LoadGrid()
        {
            XLHC_SOTHAM_BL oBL = new XLHC_SOTHAM_BL();
            decimal ID = Convert.ToDecimal(Session[ENUM_LOAIAN.BPXLHC] + "");
            DataTable oDT = oBL.XLHC_SOTHAM_KCaoKNghi_GETLIST_V2(ID);
            if (oDT != null && oDT.Rows.Count > 0)
            {
                #region "Xác định số lượng trang"
                int Total = Convert.ToInt32(oDT.Rows.Count), pageSize = 20;
                hddTotalPage.Value = Cls_Comon.GetTotalPage(Total, pageSize).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + Total.ToString() + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                             lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                #endregion
                dgList.PageSize = pageSize;
                dgList.DataSource = oDT;
                dgList.DataBind();
                pndata.Visible = true;
            }
            else
            {
                pndata.Visible = false;
            }
        }
        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            try
            {
                decimal ID = 0, IsKhangCao = 0;
                string StrPara = "";
                StrPara = e.CommandArgument.ToString();
                if (StrPara.Contains(";#"))
                {
                    string[] arr = StrPara.Split(';');
                    ID = Convert.ToDecimal(arr[0] + "");
                    IsKhangCao = Convert.ToDecimal(arr[1].Replace("#", "") + "");
                }
                switch (e.CommandName)
                {
                    case "Download":
                        string TENFILE = "";
                        byte[] NOIDUNGFILE = null;
                        string KIEUFILE = "";
                        XLHC_SOTHAM_KHANGCAO oKN = dt.XLHC_SOTHAM_KHANGCAO.Where(x => x.ID == ID).FirstOrDefault();
                        TENFILE = oKN.TENFILE;
                        NOIDUNGFILE = oKN.NOIDUNGFILE;
                        KIEUFILE = oKN.KIEUFILE;

                        if (!string.IsNullOrEmpty(TENFILE))
                        {
                            var cacheKey = Guid.NewGuid().ToString("N");
                            Context.Cache.Insert(key: cacheKey, value: NOIDUNGFILE, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
                            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download", "window.location='" + Cls_Comon.GetRootURL_HTTPS_CONFIG() + "/DownloadFile.aspx?cacheKey=" + cacheKey + "&FileName=" + TENFILE + "&Extension=" + KIEUFILE + "';", true);
                        }
                        break;
                    case "Sua":
                        lbthongbao.Text = "";
                        LoadEdit(ID, IsKhangCao);
                        hddid.Value = ID.ToString();
                        break;
                    case "Xoa":
                        decimal DonID = Convert.ToDecimal(Session[ENUM_LOAIAN.BPXLHC] + "");
                        XLHC_SOTHAM_KHANGCAO kc = dt.XLHC_SOTHAM_KHANGCAO.Where(x => x.DONID == DonID && x.GQ_TINHTRANG == 3).FirstOrDefault();
                        MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                        if (oPer.XOA == false || (btnUpdate.Enabled == false && kc == null))
                        {
                            lbthongbao.Text = "Bạn không có quyền xóa!";
                            return;
                        }
                        string StrMsg = "Không được sửa đổi thông tin.";
                        string Result = new XLHC_CHUYEN_NHAN_AN_BL().Check_NhanAn_V2(DonID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                        if (Result != "")
                        {
                            lbthongbao.Text = Result;
                            return;
                        }
                        xoa(ID);
                        break;
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        #region "Phân trang"
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            try
            {
                dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value) - 2;
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            try
            {
                dgList.CurrentPageIndex = 0;
                hddPageIndex.Value = "1";
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTLast_Click(object sender, EventArgs e)
        {
            try
            {
                dgList.CurrentPageIndex = Convert.ToInt32(hddTotalPage.Value) - 1;
                hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTNext_Click(object sender, EventArgs e)
        {
            try
            {
                dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value);
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTStep_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton lbCurrent = (LinkButton)sender;
                dgList.CurrentPageIndex = Convert.ToInt32(lbCurrent.Text) - 1;
                hddPageIndex.Value = lbCurrent.Text;
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        #endregion
        public void LoadEdit(decimal ID, decimal IsKhangCao)
        {
            lbthongbao.Text = "";
            rdbPanelKhieuNai.Visible = rdbPanelKhangNghi.Visible = false;
            if (IsKhangCao == KHIEUNAI)// khiếu nại
            {
                rdbPanelKhieuNai.SelectedValue = rdbPanelKienNghi.SelectedValue = rdbPanelKhangNghi.SelectedValue = KHIEUNAI.ToString();
                rdbPanelKhieuNai.Visible = true;
                pnKhangNghi.Visible = false;
                LoadComboboxKhieuNai();
                XLHC_SOTHAM_KHANGCAO oND = dt.XLHC_SOTHAM_KHANGCAO.Where(x => x.ID == ID).FirstOrDefault();
                if (oND != null)
                {
                    hddid.Value = oND.ID.ToString();
                    rdbHinhThucNhanDon.SelectedValue = oND.HINHTHUCNHAN.ToString();
                    txtNgayvietdonKC.Text = string.IsNullOrEmpty(oND.NGAYVIETDON + "") ? "" : ((DateTime)oND.NGAYVIETDON).ToString("dd/MM/yyyy", cul);
                    txtNgaykhangcao.Text = string.IsNullOrEmpty(oND.NGAYKHANGCAO + "") ? "" : ((DateTime)oND.NGAYKHANGCAO).ToString("dd/MM/yyyy", cul);
                    // Tìm DUONGSUID trong cả hai bảng và chọn giá trị tương ứng
                    bool found = false;
                    if (oND.DUONGSUID > 0)
                    {
                        // Kiểm tra trong XLHC_DON_THAMGIATOTUNG
                        var thamGiaTotung = dt.XLHC_DON_THAMGIATOTUNG.FirstOrDefault(x => x.ID == oND.DUONGSUID);
                        if (thamGiaTotung != null)
                        {
                            string value = thamGiaTotung.ID.ToString();
                            if (ddlNguoikhangcao.Items.FindByValue(value) != null)
                            {
                                ddlNguoikhangcao.SelectedValue = value;
                                found = true;
                            }
                        }

                        // Nếu không tìm thấy trong bảng đầu tiên, kiểm tra trong XLHC_DUONGSU
                        if (!found)
                        {
                            var duongSu = dt.XLHC_DUONGSU.FirstOrDefault(x => x.ID == oND.DUONGSUID);
                            if (duongSu != null)
                            {
                                string value = duongSu.ID.ToString();
                                if (ddlNguoikhangcao.Items.FindByValue(value) != null)
                                {
                                    ddlNguoikhangcao.SelectedValue = value;
                                    found = true;
                                }
                            }
                        }
                    }

                    LoadQD();
                    ddlSOQDBA_KC.SelectedValue = oND.SOQDBA.ToString();


                    rdbQuahan_KC.SelectedValue = oND.ISQUAHAN.ToString();
                    txtNgayQDBA_KC.Text = string.IsNullOrEmpty(oND.NGAYQDBA + "") ? "" : ((DateTime)oND.NGAYQDBA).ToString("dd/MM/yyyy", cul);
                    DM_TOAAN oToaAn = dt.DM_TOAAN.Where(x => x.ID == oND.TOAANRAQDID).FirstOrDefault();
                    if (oToaAn != null) { txtToaAnQD_KC.Text = oToaAn.TEN; } else { txtToaAnQD_KC.Text = ""; }
                    txtNoidungKC.Text = oND.NOIDUNGKHANGCAO;
                    if ((oND.TENFILE + "") != "")
                    {
                        lbtDownloadKhangCao.Visible = true;
                    }
                    else
                    { lbtDownloadKhangCao.Visible = false; }
                }
                SetRadioPanelVisible(KHIEUNAI);
                pnKhieuNai.Visible = true;
                pnKienNghi.Visible = false;
                pnKhangNghi.Visible = false;
            }
            else if (IsKhangCao == KIENNGHI)// kiến nghị
            {
                rdbPanelKhieuNai.SelectedValue = rdbPanelKienNghi.SelectedValue = rdbPanelKhangNghi.SelectedValue = KIENNGHI.ToString();
                rdbPanelKienNghi.Visible = true;
                pnKienNghi.Visible = false;
                LoadComboboxKienNghi();
                XLHC_SOTHAM_KHANGCAO oND = dt.XLHC_SOTHAM_KHANGCAO.Where(x => x.ID == ID).FirstOrDefault();
                if (oND != null)
                {
                    hddid.Value = oND.ID.ToString();
                    rdbHinhThucNhanDonKienNghi.SelectedValue = oND.HINHTHUCNHAN.ToString();
                    txtNgayvietdonKienNghi.Text = string.IsNullOrEmpty(oND.NGAYVIETDON + "") ? "" : ((DateTime)oND.NGAYVIETDON).ToString("dd/MM/yyyy", cul);
                    txtNgayKienNghi.Text = string.IsNullOrEmpty(oND.NGAYKHANGCAO + "") ? "" : ((DateTime)oND.NGAYKHANGCAO).ToString("dd/MM/yyyy", cul);
                    ddlNguoiKienNghi.SelectedValue = oND.DUONGSUID.ToString();
                    LoadQD();
                    ddlSOQDBA_KienNghi.SelectedValue = oND.SOQDBA.ToString();
                    rdbQuahan_KienNghi.SelectedValue = oND.ISQUAHAN.ToString();
                    txtNgayQDBA_KienNghi.Text = string.IsNullOrEmpty(oND.NGAYQDBA + "") ? "" : ((DateTime)oND.NGAYQDBA).ToString("dd/MM/yyyy", cul);
                    DM_TOAAN oToaAn = dt.DM_TOAAN.Where(x => x.ID == oND.TOAANRAQDID).FirstOrDefault();
                    if (oToaAn != null) { txtToaAnQD_KienNghi.Text = oToaAn.TEN; } else { txtToaAnQD_KienNghi.Text = ""; }
                    txtNoidungKienNghi.Text = oND.NOIDUNGKHANGCAO;
                    if ((oND.TENFILE + "") != "")
                    {
                        lbtDownloadKienNghi.Visible = true;
                    }
                    else
                    { lbtDownloadKienNghi.Visible = false; }
                }
                SetRadioPanelVisible(KIENNGHI);
                pnKhieuNai.Visible = false;
                pnKienNghi.Visible = true;
                pnKhangNghi.Visible = false;
            }
            else // kháng nghị
            {
                rdbPanelKhieuNai.SelectedValue = rdbPanelKienNghi.SelectedValue = rdbPanelKhangNghi.SelectedValue = KHANGNGHI.ToString();
                rdbPanelKhangNghi.Visible = true;
                pnKhangNghi.Visible = false;
                LoadComboboxKhangNghi();
                XLHC_SOTHAM_KHANGCAO oND = dt.XLHC_SOTHAM_KHANGCAO.Where(x => x.ID == ID).FirstOrDefault();
                if (oND != null)
                {
                    hddid.Value = oND.ID.ToString();
                    rdbHinhThucNhanDonKhangNghi.SelectedValue = oND.HINHTHUCNHAN.ToString();
                    txtNgayvietdonKhangNghi.Text = string.IsNullOrEmpty(oND.NGAYVIETDON + "") ? "" : ((DateTime)oND.NGAYVIETDON).ToString("dd/MM/yyyy", cul);
                    txtNgayKhangNghi.Text = string.IsNullOrEmpty(oND.NGAYKHANGCAO + "") ? "" : ((DateTime)oND.NGAYKHANGCAO).ToString("dd/MM/yyyy", cul);
                    DM_VKS oVKS = dt.DM_VKS.Where(x => x.ID == oND.DUONGSUID).FirstOrDefault();

                    if (oVKS != null)
                    {
                        string value = oVKS.ID.ToString();
                        if (ddlNguoiKhangNghi.Items.FindByValue(value) != null)
                        {
                            ddlNguoiKhangNghi.SelectedValue = value;
                        }
                    }
                    //rdbLoaiKC.SelectedValue = oND.LOAIKHANGCAO.ToString();
                    LoadQD();
                    ddlSOQDBA_KhangNghi.SelectedValue = oND.SOQDBA.ToString();
                    rdbQuahan_KhangNghi.SelectedValue = oND.ISQUAHAN.ToString();
                    txtNgayQDBA_KhangNghi.Text = string.IsNullOrEmpty(oND.NGAYQDBA + "") ? "" : ((DateTime)oND.NGAYQDBA).ToString("dd/MM/yyyy", cul);
                    DM_TOAAN oToaAn = dt.DM_TOAAN.Where(x => x.ID == oND.TOAANRAQDID).FirstOrDefault();
                    if (oToaAn != null) { txtToaAnQD_KhangNghi.Text = oToaAn.TEN; } else { txtToaAnQD_KhangNghi.Text = ""; }
                    txtNoidungKhangNghi.Text = oND.NOIDUNGKHANGCAO;
                    if ((oND.TENFILE + "") != "")
                    {
                        lbtDownloadKhangNghi.Visible = true;
                    }
                    else
                    { lbtDownloadKhangNghi.Visible = false; }
                }
                SetRadioPanelVisible(KHANGNGHI);
                pnKhieuNai.Visible = false;
                pnKienNghi.Visible = false;
                pnKhangNghi.Visible = true;
            }
        }
        public void xoa(decimal ID)
        {
            XLHC_SOTHAM_KHANGCAO oND = dt.XLHC_SOTHAM_KHANGCAO.Where(x => x.ID == ID).FirstOrDefault();
            if (oND != null)
            {
                dt.XLHC_SOTHAM_KHANGCAO.Remove(oND);
            }

            dt.SaveChanges();
            dgList.CurrentPageIndex = 0;
            LoadGrid();
            ResetControls();
            lbthongbao.Text = "Xóa thành công!";
        }
        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            try
            {
                string selectedValue = "";
                if (pnKhieuNai.Visible)
                    selectedValue = rdbPanelKhieuNai.SelectedValue;
                else if (pnKienNghi.Visible)
                    selectedValue = rdbPanelKienNghi.SelectedValue;
                else if (pnKhangNghi.Visible)
                    selectedValue = rdbPanelKhangNghi.SelectedValue;
                decimal ID = 0,
                IsKhangCao = 0,
                DonID = Convert.ToDecimal(Session[ENUM_LOAIAN.BPXLHC] + "");
                XLHC_DON oDon = dt.XLHC_DON.Where(x => x.ID == DonID).FirstOrDefault();
                if (selectedValue == KHIEUNAI.ToString())// khiếu nại
                {
                    IsKhangCao = KHIEUNAI;
                    if (!CheckValid(IsKhangCao)) return;
                    XLHC_SOTHAM_KHANGCAO oND;
                    if (hddid.Value == "" || hddid.Value == "0")
                    {
                        oND = new XLHC_SOTHAM_KHANGCAO();
                    }
                    else
                    {
                        ID = Convert.ToDecimal(hddid.Value);
                        oND = dt.XLHC_SOTHAM_KHANGCAO.Where(x => x.ID == ID).FirstOrDefault();
                    }

                    if (rdbQuahan_KC.SelectedValue == "1")
                    {
                        DM_TOAAN toa = dt.DM_TOAAN.Where(x => x.ID == oDon.TOAANID).FirstOrDefault<DM_TOAAN>();
                        if (toa != null)
                        {
                            oND.GQ_TOAANID = toa.CAPCHAID;
                        }
                        oND.GQ_TINHTRANG = 0;
                    }
                    else
                    {
                        oND.GQ_TINHTRANG = 2; // không quá hạn
                    }

                    oND.DONID = DonID;
                    oND.HINHTHUCNHAN = Convert.ToDecimal(rdbHinhThucNhanDon.SelectedValue);
                    oND.NGAYVIETDON = (String.IsNullOrEmpty(txtNgayvietdonKC.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayvietdonKC.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    oND.NGAYKHANGCAO = (String.IsNullOrEmpty(txtNgaykhangcao.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgaykhangcao.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    oND.DUONGSUID = Convert.ToDecimal(ddlNguoikhangcao.SelectedValue);
                    //oND.LOAIKHANGCAO = Convert.ToDecimal(rdbLoaiKC.SelectedValue);
                    oND.SOQDBA = Convert.ToDecimal(ddlSOQDBA_KC.SelectedValue);
                    oND.ISQUAHAN = Convert.ToDecimal(rdbQuahan_KC.SelectedValue);
                    oND.NGAYQDBA = (String.IsNullOrEmpty(txtNgayQDBA_KC.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayQDBA_KC.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

                    oND.TOAANRAQDID = oDon.TOAANID;
                    oND.NOIDUNGKHANGCAO = txtNoidungKC.Text;
                    oND.TYPE = KHIEUNAI;

                    int typeQd = 0;
                    Dictionary<string, int> mapSoQDKhieuNaiToType = GetMapSoQDToType();
                    string selected = ddlSOQDBA_KC.SelectedValue?.Trim();

                    if (!string.IsNullOrEmpty(selected) && selectedValue != "0" && mapSoQDKhieuNaiToType.TryGetValue(selected, out typeQd))
                    {
                        oND.TYPE_QD = Convert.ToDecimal(typeQd);
                    }

                    if (hddFilePath_KC.Value != "")
                    {
                        try
                        {
                            string strFilePath = hddFilePath_KC.Value.Replace("/", "\\");
                            byte[] buff = null;
                            using (FileStream fs = File.OpenRead(strFilePath))
                            {
                                BinaryReader br = new BinaryReader(fs);
                                FileInfo oF = new FileInfo(strFilePath);
                                long numBytes = oF.Length;
                                buff = br.ReadBytes((int)numBytes);
                                oND.NOIDUNGFILE = buff;
                                oND.TENFILE = Cls_Comon.ChuyenTVKhongDau(oF.Name);
                                oND.KIEUFILE = oF.Extension;
                            }
                            File.Delete(strFilePath);
                        }
                        catch (Exception ex) { lbthongbao.Text = ex.Message; }
                    }
                    if (hddid.Value == "" || hddid.Value == "0")
                    {
                        oND.NGAYTAO = DateTime.Now;
                        oND.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                        oND.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                        dt.XLHC_SOTHAM_KHANGCAO.Add(oND);
                    }
                    else
                    {
                        oND.NGAYSUA = DateTime.Now;
                        oND.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    }
                    dt.SaveChanges();
                    ID = oND.ID;
                    dgList.CurrentPageIndex = 0;
                    LoadGrid();
                    ResetControls();
                    SetRadioPanelVisible(KHIEUNAI);
                    ShowAppropriatePanel(KHIEUNAI);
                    lbthongbao.Text = "Lưu thành công!";

                }
                else if (selectedValue == KIENNGHI.ToString())// kiến nghị
                {
                    IsKhangCao = KIENNGHI;
                    if (!CheckValid(IsKhangCao)) return;
                    XLHC_SOTHAM_KHANGCAO oND;
                    if (hddid.Value == "" || hddid.Value == "0")
                    {
                        oND = new XLHC_SOTHAM_KHANGCAO();
                    }
                    else
                    {
                        ID = Convert.ToDecimal(hddid.Value);
                        oND = dt.XLHC_SOTHAM_KHANGCAO.Where(x => x.ID == ID).FirstOrDefault();
                    }

                    if (rdbQuahan_KienNghi.SelectedValue == "1")
                    {
                        DM_TOAAN toa = dt.DM_TOAAN.Where(x => x.ID == oDon.TOAANID).FirstOrDefault<DM_TOAAN>();
                        if (toa != null)
                        {
                            oND.GQ_TOAANID = toa.CAPCHAID;
                        }
                        oND.GQ_TINHTRANG = 0;
                    }

                    oND.DONID = DonID;
                    oND.HINHTHUCNHAN = Convert.ToDecimal(rdbHinhThucNhanDonKienNghi.SelectedValue);
                    oND.NGAYVIETDON = (String.IsNullOrEmpty(txtNgayvietdonKienNghi.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayvietdonKienNghi.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    oND.NGAYKHANGCAO = (String.IsNullOrEmpty(txtNgayKienNghi.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayKienNghi.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    oND.DUONGSUID = Convert.ToDecimal(ddlNguoiKienNghi.SelectedValue);
                    oND.SOQDBA = Convert.ToDecimal(ddlSOQDBA_KienNghi.SelectedValue);
                    oND.ISQUAHAN = Convert.ToDecimal(rdbQuahan_KienNghi.SelectedValue);
                    oND.NGAYQDBA = (String.IsNullOrEmpty(txtNgayQDBA_KienNghi.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayQDBA_KienNghi.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    oND.TOAANRAQDID = oDon.TOAANID;
                    oND.NOIDUNGKHANGCAO = txtNoidungKienNghi.Text;
                    oND.TYPE = KIENNGHI;
                    string selectedQDId = ddlSOQDBA_KienNghi.SelectedValue; // hoặc dùng ddlSOQDBA_KienNghi, tùy bạn


                    int typeQd = 0;
                    Dictionary<string, int> mapSoQDKhieuNaiToType = GetMapSoQDToType();
                    string selected = ddlSOQDBA_KienNghi.SelectedValue?.Trim();

                    if (!string.IsNullOrEmpty(selected) && selectedValue != "0" && mapSoQDKhieuNaiToType.TryGetValue(selected, out typeQd))
                    {
                        oND.TYPE_QD = Convert.ToDecimal(typeQd);
                    }



                    if (hddFilePath_KienNghi.Value != "")
                    {
                        try
                        {
                            string strFilePath = hddFilePath_KienNghi.Value.Replace("/", "\\");
                            byte[] buff = null;
                            using (FileStream fs = File.OpenRead(strFilePath))
                            {
                                BinaryReader br = new BinaryReader(fs);
                                FileInfo oF = new FileInfo(strFilePath);
                                long numBytes = oF.Length;
                                buff = br.ReadBytes((int)numBytes);
                                oND.NOIDUNGFILE = buff;
                                oND.TENFILE = Cls_Comon.ChuyenTVKhongDau(oF.Name);
                                oND.KIEUFILE = oF.Extension;
                            }
                            File.Delete(strFilePath);
                        }
                        catch (Exception ex) { lbthongbao.Text = ex.Message; }
                    }
                    if (hddid.Value == "" || hddid.Value == "0")
                    {
                        oND.NGAYTAO = DateTime.Now;
                        oND.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                        oND.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                        dt.XLHC_SOTHAM_KHANGCAO.Add(oND);
                    }
                    else
                    {
                        oND.NGAYSUA = DateTime.Now;
                        oND.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    }
                    dt.SaveChanges();
                    ID = oND.ID;
                    dgList.CurrentPageIndex = 0;
                    LoadGrid();
                    ResetControls();
                    SetRadioPanelVisible(KIENNGHI);

                    ShowAppropriatePanel(KIENNGHI);
                    lbthongbao.Text = "Lưu thành công!";
                }
                else  //kháng nghị
                {
                    IsKhangCao = KHANGNGHI;
                    if (!CheckValid(IsKhangCao)) return;
                    XLHC_SOTHAM_KHANGCAO oND;
                    if (hddid.Value == "" || hddid.Value == "0")
                    {
                        oND = new XLHC_SOTHAM_KHANGCAO();
                    }
                    else
                    {
                        ID = Convert.ToDecimal(hddid.Value);
                        oND = dt.XLHC_SOTHAM_KHANGCAO.Where(x => x.ID == ID).FirstOrDefault();
                    }

                    if (rdbQuahan_KhangNghi.SelectedValue == "1")
                    {
                        DM_TOAAN toa = dt.DM_TOAAN.Where(x => x.ID == oDon.TOAANID).FirstOrDefault<DM_TOAAN>();
                        if (toa != null)
                        {
                            oND.GQ_TOAANID = toa.CAPCHAID;
                        }
                        oND.GQ_TINHTRANG = 0;
                    }

                    oND.DONID = DonID;
                    oND.HINHTHUCNHAN = Convert.ToDecimal(rdbHinhThucNhanDonKhangNghi.SelectedValue);
                    oND.NGAYVIETDON = (String.IsNullOrEmpty(txtNgayvietdonKhangNghi.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayvietdonKhangNghi.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    oND.NGAYKHANGCAO = (String.IsNullOrEmpty(txtNgayKhangNghi.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayKhangNghi.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    oND.DUONGSUID = Convert.ToDecimal(ddlNguoiKhangNghi.SelectedValue);
                    oND.SOQDBA = Convert.ToDecimal(ddlSOQDBA_KhangNghi.SelectedValue);
                    oND.ISQUAHAN = Convert.ToDecimal(rdbQuahan_KhangNghi.SelectedValue);
                    oND.NGAYQDBA = (String.IsNullOrEmpty(txtNgayQDBA_KhangNghi.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayQDBA_KhangNghi.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    oND.TOAANRAQDID = oDon.TOAANID;
                    oND.NOIDUNGKHANGCAO = txtNoidungKhangNghi.Text;
                    oND.TYPE = KHANGNGHI;

                    int typeQd = 0;
                    Dictionary<string, int> mapSoQDKhieuNaiToType = GetMapSoQDToType();
                    string selected = ddlSOQDBA_KhangNghi.SelectedValue?.Trim();

                    if (!string.IsNullOrEmpty(selected) && selectedValue != "0" && mapSoQDKhieuNaiToType.TryGetValue(selected, out typeQd))
                    {
                        oND.TYPE_QD = Convert.ToDecimal(typeQd);
                    }


                    if (hddFilePath_KhangNghi.Value != "")
                    {
                        try
                        {
                            string strFilePath = hddFilePath_KhangNghi.Value.Replace("/", "\\");
                            byte[] buff = null;
                            using (FileStream fs = File.OpenRead(strFilePath))
                            {
                                BinaryReader br = new BinaryReader(fs);
                                FileInfo oF = new FileInfo(strFilePath);
                                long numBytes = oF.Length;
                                buff = br.ReadBytes((int)numBytes);
                                oND.NOIDUNGFILE = buff;
                                oND.TENFILE = Cls_Comon.ChuyenTVKhongDau(oF.Name);
                                oND.KIEUFILE = oF.Extension;
                            }
                            File.Delete(strFilePath);
                        }
                        catch (Exception ex) { lbthongbao.Text = ex.Message; }
                    }
                    if (hddid.Value == "" || hddid.Value == "0")
                    {
                        oND.NGAYTAO = DateTime.Now;
                        oND.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                        oND.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                        dt.XLHC_SOTHAM_KHANGCAO.Add(oND);
                    }
                    else
                    {
                        oND.NGAYSUA = DateTime.Now;
                        oND.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    }
                    dt.SaveChanges();
                    ID = oND.ID;

                    dgList.CurrentPageIndex = 0;
                    LoadGrid();
                    ResetControls();
                    SetRadioPanelVisible(KHANGNGHI);
                    ShowAppropriatePanel(KHANGNGHI);
                    lbthongbao.Text = "Lưu thành công!";
                }

            }
            catch (Exception ex) { lbthongbao.Text = "Lỗi: " + ex.Message; }
        }
        private bool CheckValid(decimal isKhangCao)
        {
            if (isKhangCao == KHIEUNAI)// Kháng cáo
            {
                if (rdbHinhThucNhanDon.SelectedValue == "")
                {
                    lbthongbao.Text = "Bạn chưa chọn hình thức nhận đơn. Hãy chọn lại!";
                    return false;
                }
                if (txtNgayvietdonKC.Text.Trim().Length > 0 && Cls_Comon.IsValidDate(txtNgayvietdonKC.Text) == false)
                {
                    lbthongbao.Text = "Ngày viết đơn phải theo định dạng (dd/MM/yyyy)!";
                    txtNgayvietdonKC.Focus();
                    return false;
                }
                if (Cls_Comon.IsValidDate(txtNgaykhangcao.Text) == false)
                {
                    lbthongbao.Text = "Ngày khiếu nại chưa nhập hoặc không theo định dạng (dd/MM/yyyy)!";
                    txtNgaykhangcao.Focus();
                    return false;
                }
                if (ddlNguoikhangcao.SelectedValue == "-1")
                {
                    lbthongbao.Text = "Chưa chọn người kiếu nại. Hãy chọn lại!";
                    ddlNguoikhangcao.Focus();
                    return false;
                }
                if (ddlSOQDBA_KC.SelectedValue == "0")
                {
                    lbthongbao.Text = "Bạn chưa chọn số QĐ. Hãy chọn lại!";
                    return false;
                }
                if (rdbQuahan_KC.SelectedValue == "")
                {
                    lbthongbao.Text = "Bạn chưa chọn loại khiếu nại quá hạn. Hãy chọn lại!";
                    return false;
                }

                //Kiểm tra ngày viết đơn
                DateTime dNgayVietDon = (String.IsNullOrEmpty(txtNgayvietdonKC.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayvietdonKC.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                if (dNgayVietDon > DateTime.Now)
                {
                    lbthongbao.Text = "Ngày khiếu nại không được lớn hơn ngày hiện tại!";
                    txtNgayvietdonKC.Focus();
                    return false;
                }
                //Kiểm tra ngày khiếu nại
                DateTime dNgayKC = (String.IsNullOrEmpty(txtNgaykhangcao.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgaykhangcao.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                if (dNgayKC > DateTime.Now)
                {
                    lbthongbao.Text = "Ngày khiếu nại không được lớn hơn ngày hiện tại!";
                    txtNgaykhangcao.Focus();
                    return false;
                }
                // Valid Ngay QD
                DateTime dNgayQDBA;
                string ngayQD = txtNgayQDBA_KC.Text.Trim();
                if (Cls_Comon.IsValidDate(ngayQD) == false)
                {
                    lbthongbao.Text = "Chưa nhập ngày quyết định hoặc theo định dạng (dd/MM/yyyy)!";
                    return false;
                }


                dNgayQDBA = DateTime.Parse(ngayQD, cul, DateTimeStyles.NoCurrentDateDefault);
                if (dNgayKC < dNgayQDBA)
                {
                    lbthongbao.Text = "Ngày khiếu nại không được trước ngày quyết định!";
                    txtNgaykhangcao.Focus();
                    return false;
                }
            }
            else if (isKhangCao == KIENNGHI)// kiến nghị
            {
                // Kiểm tra hình thức nhận đơn
                if (string.IsNullOrWhiteSpace(rdbHinhThucNhanDonKienNghi.SelectedValue))
                {
                    lbthongbao.Text = "Bạn chưa chọn hình thức nhận đơn. Hãy chọn lại!";
                    return false;
                }
                //Kiểm tra ngày viết đơn
                DateTime dNgayVietDon = (String.IsNullOrEmpty(txtNgayvietdonKienNghi.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayvietdonKienNghi.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                if (dNgayVietDon > DateTime.Now)
                {
                    lbthongbao.Text = "Ngày viết đơn kiến nghị không được lớn hơn ngày hiện tại!";
                    txtNgayvietdonKienNghi.Focus();
                    return false;
                }
                //Kiểm tra ngày kiến nghị
                DateTime dNgayKienNghi;
                string ngayKienNghi = txtNgayKienNghi.Text.Trim();

                if (Cls_Comon.IsValidDate(ngayKienNghi) == false)
                {
                    lbthongbao.Text = "Chưa nhập ngày kiến nghị hoặc theo định dạng (dd/MM/yyyy)!";
                    txtNgayKienNghi.Focus();
                    return false;
                }
                dNgayKienNghi = DateTime.Parse(ngayKienNghi, cul, DateTimeStyles.NoCurrentDateDefault);
                if (dNgayKienNghi > DateTime.Now)
                {
                    lbthongbao.Text = "Ngày kiến nghị không được lớn hơn ngày hiện tại!";
                    txtNgayKienNghi.Focus();
                    return false;
                }


                // Kiểm tra cơ quan kiến nghị
                if (ddlNguoiKienNghi.SelectedValue == "-1")
                {
                    lbthongbao.Text = "Chưa chọn CQ đề nghị. Hãy chọn lại!";
                    ddlNguoiKienNghi.Focus();
                    return false;
                }

                // Kiểm tra số quyết định
                if (ddlSOQDBA_KienNghi.SelectedValue == "0")
                {
                    lbthongbao.Text = "Bạn chưa chọn số QĐ. Hãy chọn lại!";
                    return false;
                }

                // Kiểm tra trạng thái quá hạn
                if (string.IsNullOrWhiteSpace(rdbQuahan_KienNghi.SelectedValue))
                {
                    lbthongbao.Text = "Bạn chưa chọn loại kiến nghị quá hạn. Hãy chọn lại!";
                    return false;
                }

                // Kiểm tra ngày quyết định
                DateTime dNgayQDBA;
                string ngayQD = txtNgayQDBA_KienNghi.Text.Trim();
                if (Cls_Comon.IsValidDate(ngayQD) == false)
                {
                    lbthongbao.Text = "Chưa nhập ngày kiến nghị hoặc theo định dạng (dd/MM/yyyy)!!";
                    return false;
                }


                dNgayQDBA = DateTime.Parse(ngayQD, cul, DateTimeStyles.NoCurrentDateDefault);

                if (dNgayKienNghi < dNgayQDBA)
                {
                    lbthongbao.Text = "Ngày kiến nghị không được trước ngày quyết định!";
                    txtNgaykhangcao.Focus();
                    return false;
                }


            }
            else// Kháng nghị
            {
                if (rdbHinhThucNhanDonKhangNghi.SelectedValue == "")
                {
                    lbthongbao.Text = "Bạn chưa chọn hình thức nhận đơn. Hãy chọn lại!";
                    return false;
                }
                if (txtNgayvietdonKhangNghi.Text.Trim().Length > 0 && Cls_Comon.IsValidDate(txtNgayvietdonKhangNghi.Text) == false)
                {
                    lbthongbao.Text = "Ngày viết đơn phải theo định dạng (dd/MM/yyyy)!";
                    txtNgayvietdonKC.Focus();
                    return false;
                }
                if (Cls_Comon.IsValidDate(txtNgayKhangNghi.Text) == false)
                {
                    lbthongbao.Text = "Ngày kháng nghị chưa nhập hoặc không theo định dạng (dd/MM/yyyy)!";
                    txtNgayKienNghi.Focus();
                    return false;
                }
                if (ddlNguoiKhangNghi.SelectedValue == "-1")
                {
                    lbthongbao.Text = "Chưa chọn VKS cùng cấp. Hãy chọn lại!";
                    ddlNguoikhangcao.Focus();
                    return false;
                }

                if (ddlSOQDBA_KhangNghi.SelectedValue == "0")
                {
                    lbthongbao.Text = "Bạn chưa chọn số QĐ. Hãy chọn lại!";
                    return false;
                }
                if (rdbQuahan_KhangNghi.SelectedValue == "")
                {
                    lbthongbao.Text = "Bạn chưa chọn kháng nghị quá hạn. Hãy chọn lại!";
                    return false;
                }
                //Kiểm tra ngày viết đơn
                DateTime dNgayVietDon = (String.IsNullOrEmpty(txtNgayvietdonKhangNghi.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayvietdonKhangNghi.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

                if (dNgayVietDon > DateTime.Now)
                {
                    lbthongbao.Text = "Ngày viết kháng nghị không được lớn hơn ngày hiện tại!";
                    txtNgayvietdonKhangNghi.Focus();
                    return false;
                }

                //Kiểm tra ngày kháng nghị
                DateTime dNgayKhangNghi;
                string ngayKhangNghi = txtNgayKhangNghi.Text.Trim();

                if (Cls_Comon.IsValidDate(ngayKhangNghi) == false)
                {
                    lbthongbao.Text = "Chưa nhập ngày kháng nghị hoặc theo định dạng (dd/MM/yyyy)!";
                    txtNgayKienNghi.Focus();
                    return false;
                }
                dNgayKhangNghi = DateTime.Parse(ngayKhangNghi, cul, DateTimeStyles.NoCurrentDateDefault);
                if (dNgayKhangNghi > DateTime.Now)
                {
                    lbthongbao.Text = "Ngày kháng nghị không được lớn hơn ngày hiện tại!";
                    txtNgayKienNghi.Focus();
                    return false;
                }

                if (dNgayKhangNghi > DateTime.Now)
                {
                    lbthongbao.Text = "Ngày kháng nghị không được lớn hơn ngày hiện tại!";
                    txtNgaykhangcao.Focus();
                    return false;
                }

                // Valid Ngay QD
                DateTime dNgayQDBA;
                string ngayQD = txtNgayQDBA_KhangNghi.Text.Trim();
                if (Cls_Comon.IsValidDate(ngayQD) == false)
                {
                    lbthongbao.Text = "Chưa nhập ngày quyết định hoặc theo định dạng (dd/MM/yyyy)!";
                    return false;
                }

                dNgayQDBA = DateTime.Parse(ngayQD, cul, DateTimeStyles.NoCurrentDateDefault);

                if (dNgayKhangNghi < dNgayQDBA)
                {
                    lbthongbao.Text = "Ngày kháng nghị không được trước ngày quyết định!";
                    txtNgaykhangcao.Focus();
                    return false;
                }
            }
            return true;
        }

        protected void btnLammoi_Click(object sender, EventArgs e)
        {
            ResetControls();
        }

        protected void txtNgaykhangcao_TextChanged(object sender, EventArgs e)
        {
            if (rdbHinhThucNhanDon.SelectedIndex != -1)
            {
                int hinhthuc_nhandon = Convert.ToInt16(rdbHinhThucNhanDon.SelectedValue);
             }
         }
        void CheckNgayKCQuaHan()
        {
            int songay = 15;
            DateTime ngaysosanh = new DateTime();
            DateTime ngaykc = (String.IsNullOrEmpty(txtNgaykhangcao.Text.Trim())) ? DateTime.MinValue : Convert.ToDateTime(txtNgaykhangcao.Text.Trim(), cul);
            Decimal banan_qd_id = Convert.ToDecimal(ddlSOQDBA_KC.SelectedValue);
            //truc tiep
            if (banan_qd_id > 0)
            {
                //khang cao quyet dinh
                //Neu la quyet dinh đinh chi/tạm dinh chi --> songay =7
                XLHC_SOTHAM_QUYETDINH obj = dt.XLHC_SOTHAM_QUYETDINH.Where(x => x.ID == banan_qd_id).FirstOrDefault();
                if (obj != null)
                {
                    ngaysosanh = Convert.ToDateTime(obj.NGAYQD);
                    decimal loaiqd_id = Convert.ToDecimal(obj.LOAIQDID);
                    DM_QD_LOAI objLoaiQD = dt.DM_QD_LOAI.Where(x => x.ID == loaiqd_id).FirstOrDefault();
                    if (objLoaiQD != null)
                    {
                        if (objLoaiQD.MA == "TDC" || objLoaiQD.MA == "DC")
                            songay = 7;
                    }
                }

                if (ngaykc <= (ngaysosanh.AddDays(songay)))
                    rdbQuahan_KC.SelectedValue = "0";
                else
                    rdbQuahan_KC.SelectedValue = "1";
            }
        }
        protected void rdbPanelKhieuNai_SelectedIndexChanged(object sender, EventArgs e)
        {
            lbthongbao.Text = "";
            int selectedValue = Convert.ToInt32(rdbPanelKhieuNai.SelectedValue);

            // Đồng bộ giá trị cho các RadioButtonList khác
            rdbPanelKhangNghi.SelectedValue = selectedValue.ToString();
            rdbPanelKienNghi.SelectedValue = selectedValue.ToString();

            // Hiển thị panel phù hợp
            ShowAppropriatePanel(selectedValue);
        }

        protected void rdbPanelKhangNghi_SelectedIndexChanged(object sender, EventArgs e)
        {
            lbthongbao.Text = "";
            int selectedValue = Convert.ToInt32(rdbPanelKhangNghi.SelectedValue);

            // Đồng bộ giá trị cho các RadioButtonList khác
            rdbPanelKhieuNai.SelectedValue = selectedValue.ToString();
            rdbPanelKienNghi.SelectedValue = selectedValue.ToString();

            // Hiển thị panel phù hợp
            ShowAppropriatePanel(selectedValue);
        }

        protected void rdbPanelKienNghi_SelectedIndexChanged(object sender, EventArgs e)
        {
            lbthongbao.Text = "";
            int selectedValue = Convert.ToInt32(rdbPanelKienNghi.SelectedValue);

            // Đồng bộ giá trị cho các RadioButtonList khác
            rdbPanelKhieuNai.SelectedValue = selectedValue.ToString();
            rdbPanelKhangNghi.SelectedValue = selectedValue.ToString();

            // Hiển thị panel phù hợp
            ShowAppropriatePanel(selectedValue);
        }

        // Hàm trợ giúp để hiển thị đúng panel dựa vào giá trị đã chọn
        private void ShowAppropriatePanel(decimal selectedValue)
        {

            if (selectedValue == KHIEUNAI) // Khiếu nại
            {
                pnKhieuNai.Visible = true;
                pnKienNghi.Visible = false;
                pnKhangNghi.Visible = false;
                LoadComboboxKhieuNai();
            }
            else if (selectedValue == KIENNGHI) // Kiến nghị
            {
                pnKhieuNai.Visible = false;
                pnKienNghi.Visible = true;
                pnKhangNghi.Visible = false;
                LoadComboboxKienNghi();
            }
            else if (selectedValue == KHANGNGHI) // Kháng nghị
            {
                pnKhieuNai.Visible = false;
                pnKienNghi.Visible = false;
                pnKhangNghi.Visible = true;
                LoadComboboxKhangNghi();
            }
        }
        private void SetRadioPanelVisible(decimal type)
        {
            rdbPanelKhieuNai.Visible = true;
            rdbPanelKienNghi.Visible = true;
            rdbPanelKhangNghi.Visible = true;


        }
        private void LoadQuyetDinhCommon<T>(
            IEnumerable<T> items,
            Func<T, string> getSoQD,
            Func<T, string> getDisplayText,
            Func<T, string> getID,
            Dictionary<string, int> map,
            int type,
            DropDownList ddl)
        {
            foreach (var item in items)
            {
                string id = getID(item);
                string text = getDisplayText(item);
                map[id] = type;
                ddl.Items.Add(new ListItem(text, id));
            }
        }

        private void LoadSoThamQuyetDinh463(decimal DonID, DropDownList ddl, Dictionary<string, int> map)
        {
            try
            {
                var soQD = (from dqq in dt.DM_QD_QUYETDINH
                            join xsq in dt.XLHC_SOTHAM_QUYETDINH on dqq.ID equals xsq.QUYETDINHID
                            where xsq.DONID == DonID
                                  && dqq.ISSOTHAM == 1
                                  && dqq.KET_THUC == 0
                                  && dqq.ID == 463
                            select new
                            {
                                xsq.SOQD,
                                dqq.TEN,
                                dqq.ID
                            }).FirstOrDefault();

                if (soQD != null && !string.IsNullOrEmpty(soQD.SOQD))
                {
                    map[soQD.ID.ToString()] = 1;
                    ddl.Items.Add(new ListItem(soQD.SOQD + " - " + soQD.TEN, soQD.ID.ToString()));
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Lỗi khi lấy dữ liệu SoThamQuyetDinh463: " + ex.Message);
            }
        }

        private void LoadQD()
        {
            decimal DonID = 0;
            if (Session[ENUM_LOAIAN.BPXLHC] != null)
            {
                decimal.TryParse(Session[ENUM_LOAIAN.BPXLHC].ToString(), out DonID);
            }

            XLHC_SOTHAM_BL oBL = new XLHC_SOTHAM_BL();
            DataTable oDT = oBL.GetList_KienNghiQuyetDinh(DonID);

            // Xóa các item cũ trước khi thêm mới
            ddlSOQDBA_KC.Items.Clear();
            ddlSOQDBA_KienNghi.Items.Clear();
            ddlSOQDBA_KhangNghi.Items.Clear();

            // Thêm item mặc định (nếu cần)
            ddlSOQDBA_KC.Items.Add(new ListItem("-- Chọn --", "0"));
            ddlSOQDBA_KienNghi.Items.Add(new ListItem("-- Chọn --", "0"));
            ddlSOQDBA_KhangNghi.Items.Add(new ListItem("-- Chọn --", "0"));
            Dictionary<string, int> mapSoQDType = new Dictionary<string, int>();
            
            // Load dữ liệu từ Business Layer
            foreach (DataRow row in oDT.Rows)
            {
                int quyetDinhId = Convert.ToInt32(row["QUYETDINHID"]);
                string soQD = row["SO_QUYETDINH"].ToString();
                string tenQD = row["TEN"].ToString();
                string loaiType = row["type"].ToString(); // Có dạng '1|xxx', '2|xxx'...

                string value = quyetDinhId.ToString();
                string text = soQD + " - " + tenQD;

                // Lưu loại type để xử lý sau nếu cần (ví dụ xử lý riêng theo loại)
                if (!string.IsNullOrEmpty(soQD))
                {
                    mapSoQDType[value] = GetLoaiFromType(loaiType);
                }
                // Thêm vào 3 DropDownList
                ddlSOQDBA_KC.Items.Add(new ListItem(text, value));
                ddlSOQDBA_KienNghi.Items.Add(new ListItem(text, value));
                ddlSOQDBA_KhangNghi.Items.Add(new ListItem(text, value));
            }
            
            SetMapSoQDToType(mapSoQDType);
        }

        private int GetLoaiFromType(string typeString)
        {
            if (!string.IsNullOrEmpty(typeString))
            {
                var parts = typeString.Split('|');
                if (parts.Length > 0)
                {
                    int loai;
                    if (int.TryParse(parts[0], out loai))
                    {
                        return loai;
                    }
                }
            }
            return 0;
        }


        private void KiemTraDonXL()
        {
            // án chuyển đi rồi thì không hiển thị
            string current_id = Session[ENUM_LOAIAN.BPXLHC] + "";
            decimal donID = Convert.ToDecimal(current_id);
            var anXL = dt.XLHC_CHUYEN_NHAN_AN.Where(x => x.VUANID == donID).FirstOrDefault();
            if (anXL != null)
            {
                Cls_Comon.SetButton(btnUpdate, false);
                Cls_Comon.SetButton(btnLammoi, false);
                lbthongbao.Text = "Vụ việc đã được chuyển lên tòa cấp trên, không được sửa đổi!";
            }
        }

    }

}