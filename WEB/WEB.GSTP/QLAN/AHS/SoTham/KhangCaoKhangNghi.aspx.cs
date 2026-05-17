using BL.GSTP;
using BL.GSTP.ADS;
using BL.GSTP.AHS;
using BL.GSTP.QLAN;
using DAL.GSTP;
using DevExpress.Utils.Extensions;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.QLAN.AHS.SoTham
{
    public partial class KhangCaoKhangNghi : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        private const decimal KHANGCAO = 1, KHANGNGHI = 2;
        public decimal VuAnID = 0;

        public string NgaySoSanh;

        protected void Page_Load(object sender, EventArgs e)
        {
            VuAnID = (String.IsNullOrEmpty(Session[ENUM_LOAIAN.AN_HINHSU] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");

            if (!IsPostBack)
            {
                string current_id = Session[ENUM_LOAIAN.AN_HINHSU] + "";
                if (current_id == "") Response.Redirect(Cls_Comon.GetRootURL() + "/QLAN/AHS/Hoso/Danhsach.aspx");
                LoadComboboxKhangCao();
                LoadComboboxKhangNghi();
                CheckQuyen();
                LoadGrid();
            }
            NgaySoSanh = txtNgayQDBA_KC.Text;
        }
        void CheckQuyen()
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            Cls_Comon.SetButton(btnUpdate, oPer.CAPNHAT);
            Cls_Comon.SetButton(btnLammoi, oPer.CAPNHAT);

            //---------------------------------
            AHS_VUAN oT = dt.AHS_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault();
            //check vu an ket thuc de thong bao khong cho sua. Có kháng cáo và bản án từ toà cũ thì toà mới không được phép thêm -> hiện kết thúc
            decimal donviID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            Boolean anKetThuc = Session[ENUM_LOAIAN.AN_DA_KET_THUC] != null ? Convert.ToBoolean(Session[ENUM_LOAIAN.AN_DA_KET_THUC]) : false;
            Boolean khangCao = dt.AHS_SOTHAM_KHANGCAO.Any(x => x.VUANID == VuAnID && x.TOA_GIAIQUYET_ID != donviID);
            if (anKetThuc && khangCao)
            {
                lbthongbao.Text = "Vụ việc đã kết thúc tại tòa cũ, không thể chỉnh sửa tại tòa mới !";
                Cls_Comon.SetButton(btnUpdate, false);
                Cls_Comon.SetButton(btnLammoi, false);
                hddShowCommand.Value = "False";
                return;
            }
            //if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.THULYGDT)
            //{
            //    lbthongbao.Text = "Vụ việc đã được chuyển lên tòa cấp trên, không được sửa đổi !";
            //    Cls_Comon.SetButton(btnUpdate, false);
            //    Cls_Comon.SetButton(btnLammoi, false);
            //    hddShowCommand.Value = "False";
            //    return;
            //}
            List<AHS_SOTHAM_THULY> lstCount = dt.AHS_SOTHAM_THULY.Where(x => x.VUANID == VuAnID).ToList();
            if (lstCount.Count == 0)
            {
                lbthongbao.Text = "Chưa cập nhật thông tin thụ lý sơ thẩm !";
                Cls_Comon.SetButton(btnUpdate, false);
                Cls_Comon.SetButton(btnLammoi, false);
                return;
            }
            List<AHS_THAMPHANGIAIQUYET> lstTP = dt.AHS_THAMPHANGIAIQUYET.Where(x => x.VUANID == VuAnID && x.MAVAITRO == ENUM_VAITROTHAMPHAN.VTTP_GIAIQUYETSOTHAM).ToList();
            if (lstTP.Count == 0)
            {
                lbthongbao.Text = "Chưa phân công thẩm phán giải quyết !";
                Cls_Comon.SetButton(btnUpdate, false);
                Cls_Comon.SetButton(btnLammoi, false);
                return;
            }

            //AHS_SOTHAM_THULY objTL = dt.AHS_SOTHAM_THULY.Where(x => x.VUANID == ID).Single<AHS_SOTHAM_THULY>();
            //NgaySoSanh = ((DateTime)objTL.NGAYTHULY).ToString("dd/MM/yyyy", cul);
            List<AHS_SOTHAM_CAOTRANG_DIEULUAT> lst = dt.AHS_SOTHAM_CAOTRANG_DIEULUAT.Where(x => x.VUANID == VuAnID).ToList();
            if (lst == null || lst.Count == 0)
            {
                lbthongbao.Text = "Bị cáo chưa có tội danh. Đề nghị cập nhật lại!";
                Cls_Comon.SetButton(btnUpdate, false);
                Cls_Comon.SetButton(btnLammoi, false);
                return;
            }
            string StrMsg = "Không được sửa đổi thông tin.";
            string Result = new AHS_CHUYEN_NHAN_AN_BL().Check_NhanAn(VuAnID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
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

                string current_id = Session[ENUM_LOAIAN.AN_HINHSU] + "";
                // Chuyen an roi van cho nhap Kháng cáo nhưng không được xóa kháng cao kháng nghị cũ
                decimal DONID = Convert.ToDecimal(current_id);
                AHS_VUAN oT = dt.AHS_VUAN.Where(x => x.ID == DONID).FirstOrDefault();
                AHS_VUAN_GIAIDOAN gd = dt.AHS_VUAN_GIAIDOAN.Where(x => x.VUANID == DONID && x.MAGIAIDOAN == ENUM_GIAIDOANVUAN.SOTHAM).FirstOrDefault();
                if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.THULYGDT)
                {
                    //lblSua.Text = "Chi tiết";
                    //lbtXoa.Visible = false;
                    rdbPanelKC.Enabled = false;
                    rdbPanelKC.SelectedValue = "1";
                }
                //if (hddShowCommand.Value == "False")
                //{
                //    lblSua.Text = "Chi tiết";
                //    lbtXoa.Visible = false;
                //}
                ImageButton lblDownload = (ImageButton)e.Item.FindControl("lblDownload");
                if (rowView["TENFILE"] + "" == "")
                {
                    lblDownload.Visible = false;
                }
                else
                {
                    lblDownload.Visible = true;
                }

                //Kiem tra neu duyet Khang cao rồi thi không cho sửa hoặc xóa ID
                DataRowView dv = (DataRowView)e.Item.DataItem;
                Decimal IsKhangCao = Convert.ToDecimal(rowView["IsKhangCao"]);
                Decimal idKC = Convert.ToDecimal(dv["ID"]);
                decimal toaAnId = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                if (IsKhangCao == 1)
                {
                    AHS_SOTHAM_KHANGCAO oKC = dt.AHS_SOTHAM_KHANGCAO.Where(x => x.VUANID == VuAnID && x.ID == idKC).FirstOrDefault();
                    if (oKC != null)
                    {
                        //Đã được duyet khang cao
                        if (oKC.GQ_TINHTRANG == 1 || oKC.TINHTRANG_GIAIQUYET == 2 || oKC.TINHTRANG_GIAIQUYET == 1)
                        {
                            lblSua.Text = "Chi tiết";
                            lbtXoa.Visible = false;
                            return;
                        }

                        string StrMsg = "Không được sửa đổi thông tin.";
                        string Result = new AHS_CHUYEN_NHAN_AN_BL().Check_NhanAn(DONID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                        if (Result == "")
                        {
                            lblSua.Text = "Sửa";
                            lbtXoa.Visible = true;
                            return;
                        }
                        else
                        {
                            if (oKC.ISQUAHAN == 1)
                            {
                                //da duyet thi khong cho sua, xoa
                                //Chua duyệt thi cho sửa xóa
                                if (oKC.GQ_TINHTRANG == 1)
                                {
                                    lblSua.Text = "Chi tiết"; lbtXoa.Visible = false;
                                }

                                else
                                    lblSua.Visible = lbtXoa.Visible = true;
                            }
                            //Nếu không phải quá hạn thi không cho sưa xóa
                            else
                            {
                                lblSua.Text = "Chi tiết";
                                lbtXoa.Visible = false;
                            }
                        }
                        AHS_CHUYEN_NHAN_AN cn = dt.AHS_CHUYEN_NHAN_AN.Where(x => x.VUANID == VuAnID && x.TOACHUYENID == toaAnId).OrderByDescending(x => x.NGAYTAO).FirstOrDefault();
                        if (cn != null)
                        {
                            if (oKC.NGAYTAO < cn.NGAYTAO)
                            {
                                lblSua.Text = "Chi tiết";
                                lbtXoa.Visible = false;
                                return;
                            }
                        }
                    }
                }
                else
                {
                    AHS_SOTHAM_KHANGNGHI oKN = dt.AHS_SOTHAM_KHANGNGHI.Where(x => x.ID == idKC).FirstOrDefault();
                    if (oKN != null)
                    {
                        if (oKN.TINHTRANG_GIAIQUYET == 3 || oKN.TINHTRANG_GIAIQUYET == 1)
                        {
                            lblSua.Text = "Chi tiết";
                            lbtXoa.Visible = false;
                            return;
                        }
                        AHS_CHUYEN_NHAN_AN cn = dt.AHS_CHUYEN_NHAN_AN.Where(x => x.VUANID == VuAnID && x.TOACHUYENID == toaAnId).OrderByDescending(x => x.NGAYTAO).FirstOrDefault();
                        if (cn != null)
                        {
                            if (oKN.NGAYTAO < cn.NGAYTAO)
                            {
                                lblSua.Text = "Chi tiết";
                                lbtXoa.Visible = false;
                                return;
                            }
                        }
                    }
                }
                if (rowView["READONLY"].ToString() == "1")
                {
                    lblSua.Text = "Chi tiết";
                    lbtXoa.Visible = false;
                    return;
                }

                // check quyền để hiển thị nút xoá
                string toaGiaiQuyetID = e.Item.Cells[13].Text.ToString();
                string donviID = Session[ENUM_SESSION.SESSION_DONVIID]?.ToString();
                if (toaGiaiQuyetID != donviID)
                {
                    lblSua.Visible = false;
                    lbtXoa.Visible = false;
                }
                Boolean anKetThuc = Session[ENUM_LOAIAN.AN_DA_KET_THUC] != null ? Convert.ToBoolean(Session[ENUM_LOAIAN.AN_DA_KET_THUC]) : false;
                if (anKetThuc)
                {
                    lblSua.Visible = false;
                    lbtXoa.Visible = false;
                }
            }
        }
        #region Kháng cáo
        private void LoadComboboxKhangCao()
        {
            //Load ds bi can 
            Load_ListBiCan();
            LoadNguoibiKhangCao();
            LoadQD_BAKhangCao();
            lbNguoiBiKC.Visible = false;
            plNguoiBiKC.Visible = false;
            // Load yêu cầu
            LoadCheckListYeuCau(KHANGCAO);
        }
        void Load_ListBiCan()
        {
            ddlNguoikhangcao.Items.Clear();
            AHS_BICANBICAO_BL oBL = new AHS_BICANBICAO_BL();
            ddlNguoikhangcao.DataSource = oBL.AHS_BICANBICAO_GetListByVuAn(VuAnID);
            ddlNguoikhangcao.DataTextField = "ArrBiCao";
            ddlNguoikhangcao.DataValueField = "ID";
            ddlNguoikhangcao.DataBind();
            ddlNguoikhangcao.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
        }
        void LoadNguoibiKhangCao()
        {
            lbNguoiBiKC.Items.Clear();
            List<AHS_BICANBICAO> listBiCan = dt.AHS_BICANBICAO.Where(x => x.VUANID == VuAnID && x.GDTAOHS == null).OrderBy(x => x.HOTEN).ToList<AHS_BICANBICAO>();
            int loai = Convert.ToInt16(rdbLoaiNguoiKC.SelectedValue);
            if (listBiCan != null)
            {
                int count_item = listBiCan.Count;
                if (count_item > 0)
                {
                    lbNguoiBiKC.DataSource = listBiCan;
                    lbNguoiBiKC.DataTextField = "HOTEN";
                    lbNguoiBiKC.DataValueField = "ID";
                    lbNguoiBiKC.DataBind();
                }
            }
            else
                lbNguoiBiKC.Items.Add(new ListItem("--- Chọn ---", "0"));
            //lbNguoiBiKC.Items[0].Selected = true;
        }
        void Load_ListNguoiThamGiaToTung()
        {
            ddlNguoikhangcao.Items.Clear();
            List<AHS_NGUOITHAMGIATOTUNG> lst = dt.AHS_NGUOITHAMGIATOTUNG.Where(x => x.VUANID == VuAnID).ToList();
            if (lst != null && lst.Count > 0)
            {
                foreach (AHS_NGUOITHAMGIATOTUNG item in lst)
                    ddlNguoikhangcao.Items.Add(new ListItem(item.HOTEN, item.ID.ToString()));
            }
            else
                ddlNguoikhangcao.Items.Add(new ListItem("--- Chọn ---", "0"));
        }
        protected void rdbLoaiNguoiKC_SelectedIndexChanged(object sender, EventArgs e)
        {
            loadLoaiNguoiKC();
        }
        private void loadLoaiNguoiKC()
        {
            int loai = Convert.ToInt16(rdbLoaiNguoiKC.SelectedValue);
            switch (loai)
            {
                case 0:
                    Load_ListBiCan();
                    lbNguoiBiKC.Visible = false;
                    plNguoiBiKC.Visible = false;
                    break;
                case 1:
                    Load_ListNguoiThamGiaToTung();
                    lbNguoiBiKC.Visible = true;
                    plNguoiBiKC.Visible = true;
                    break;
            }
            LoadQD_BAKhangCao();
        }
        protected void rdbLoaiKC_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                if (rdbLoaiKC.SelectedValue == "2")
                {
                    PanelIsQDVuAnKC.Visible = true;
                    rdbIsQDVuAnKC.SelectedValue = "0";
                }
                else
                {
                    PanelIsQDVuAnKC.Visible = false;
                    rdbIsQDVuAnKC.SelectedValue = "0";
                }
                LoadQD_BAKhangCao();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }

        private void LoadQD_BAKhangCao()
        {
            ddlSOQDBA_KC.Items.Clear();
            decimal VuAnID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");
            if (rdbLoaiKC.SelectedValue == "0")
                LoadDrop_ST_BanAn(ddlSOQDBA_KC, VuAnID);
            else if (rdbLoaiKC.SelectedValue == "1")
                LoadDrop_ST_QuyetDinhVuAn(ddlSOQDBA_KC, VuAnID, 1, false);
            else if (rdbLoaiKC.SelectedValue == "2")
                LoadDrop_ST_QuyetDinhVuAn(ddlSOQDBA_KC, VuAnID, 2, rdbIsQDVuAnKC.SelectedValue == "1" ? true : false, rdbLoaiNguoiKC.SelectedValue == "0" ? ddlNguoikhangcao.SelectedValue : null);
            LoadQD_BA_InfoKhangCao();
        }

        private void LoadQD_BA_InfoKhangCao()
        {
            if (ddlSOQDBA_KC.SelectedValue == "0")
                return;
            if (rdbLoaiKC.SelectedValue == "0")
            {
                decimal ID = Convert.ToDecimal(ddlSOQDBA_KC.SelectedValue);
                AHS_SOTHAM_BANAN oT = dt.AHS_SOTHAM_BANAN.Where(x => x.ID == ID).FirstOrDefault();
                if (oT != null)
                    txtNgayQDBA_KC.Text = string.IsNullOrEmpty(oT.NGAYBANAN + "") ? "" : ((DateTime)oT.NGAYBANAN).ToString("dd/MM/yyyy", cul);
                else
                    txtNgayQDBA_KC.Text = "";
            }
            else if (rdbLoaiKC.SelectedValue == "2" && rdbIsQDVuAnKC.SelectedValue != "1")
            {
                decimal ID = Convert.ToDecimal(ddlSOQDBA_KC.SelectedValue);
                AHS_SOTHAM_QUYETDINH_VUAN oT = dt.AHS_SOTHAM_QUYETDINH_VUAN.Where(x => x.ID == ID).FirstOrDefault();
                if (oT != null)
                    txtNgayQDBA_KC.Text = string.IsNullOrEmpty(oT.NGAYQD + "") ? "" : ((DateTime)oT.NGAYQD).ToString("dd/MM/yyyy", cul);
                else
                    txtNgayQDBA_KC.Text = "";
            }
            else
            {
                decimal ID = Convert.ToDecimal(ddlSOQDBA_KC.SelectedValue);
                AHS_SOTHAM_QUYETDINH_BICAN oT = dt.AHS_SOTHAM_QUYETDINH_BICAN.Where(x => x.ID == ID).FirstOrDefault();
                if (oT != null)
                    txtNgayQDBA_KC.Text = string.IsNullOrEmpty(oT.NGAYQD + "") ? "" : ((DateTime)oT.NGAYQD).ToString("dd/MM/yyyy", cul);
                else
                    txtNgayQDBA_KC.Text = "";
            }
            decimal VuAnID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");
            AHS_VUAN oVuAn = dt.AHS_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault();
            if (oVuAn != null)
            {
                DM_TOAAN oToaAn = dt.DM_TOAAN.Where(x => x.ID == oVuAn.TOAANID).FirstOrDefault();
                if (oToaAn != null)
                    txtToaAnQD_KC.Text = oToaAn.TEN;
                else txtToaAnQD_KC.Text = "";
            }
            else
                txtToaAnQD_KC.Text = "";
        }
        protected void lbtDownloadKhangCao_Click(object sender, EventArgs e)
        {
            decimal ID = Convert.ToDecimal(hddid.Value);
            AHS_SOTHAM_KHANGCAO oND = dt.AHS_SOTHAM_KHANGCAO.Where(x => x.ID == ID).FirstOrDefault();
            if (oND.TENFILE != "")
            {
                var cacheKey = Guid.NewGuid().ToString("N");
                Context.Cache.Insert(key: cacheKey, value: oND.NOIDUNGFILE, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download", "window.location='" + Cls_Comon.GetRootURL_HTTPS() + "/DownloadFile.aspx?cacheKey=" + cacheKey + "&FileName=" + oND.TENFILE + "&Extension=" + oND.KIEUFILE + "';", true);
            }
        }

        protected void ddlSOQDBA_KC_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                LoadQD_BA_InfoKhangCao();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
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
        #endregion
        #region Kháng nghị
        private void LoadComboboxKhangNghi()
        {
            LoadQD_BAKhangNghi();
            LoadNguoiBiKhangNghi();
            // Load yêu cầu
            LoadCheckListYeuCau(KHANGNGHI);
        }
        private void LoadQD_BAKhangNghi()
        {
            ddlSOQDBAKhangNghi.Items.Clear();
            decimal VuAnID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");
            //string NguoiBiKN = "";
            //if (lbNguoiBiKN.SelectedValue == "0" || lbNguoiBiKN.SelectedValue == "") return;
            //if (lbNguoiBiKN.Items.Count > 0)
            //{
            //    for (int i = 0; i < lbNguoiBiKN.Items.Count; i++)
            //    {
            //        if (lbNguoiBiKN.Items[i].Selected)
            //        {
            //            NguoiBiKN = lbNguoiBiKN.Items[i].Value;
            //        }
            //    }
            //}
            //NguoiBiKN = String.IsNullOrEmpty(NguoiBiKN) ? "0" : NguoiBiKN;

            string listNguoiBiKN = "";
            if (lbNguoiBiKC.Items.Count > 0)
            {
                for (int i = 0; i < lbNguoiBiKN.Items.Count; i++)
                {
                    if (lbNguoiBiKN.Items[i].Selected)
                    {
                        listNguoiBiKN = listNguoiBiKN + lbNguoiBiKN.Items[i].Value + ",";
                    }
                }
            }
            if (rdbLoaiKN.SelectedValue == "0")
                LoadDrop_ST_BanAn(ddlSOQDBAKhangNghi, VuAnID);
            else if (rdbLoaiKN.SelectedValue == "1")
                LoadDrop_ST_QuyetDinhVuAn(ddlSOQDBAKhangNghi, VuAnID, 1, false);
            else if (rdbLoaiKN.SelectedValue == "2")
                LoadDrop_ST_QuyetDinhVuAn(ddlSOQDBAKhangNghi, VuAnID, 2, rdbIsQDVuAnKN.SelectedValue == "1" ? true : false, listNguoiBiKN);

          
            LoadQD_BA_InfoKhangNghi();
        }
        private void LoadNguoiBiKhangNghi()
        {
            lbNguoiBiKN.Items.Clear();
            List<AHS_BICANBICAO> listBiCan = dt.AHS_BICANBICAO.Where(x => x.VUANID == VuAnID && x.GDTAOHS == null).OrderBy(x => x.HOTEN).ToList<AHS_BICANBICAO>();
            if (listBiCan != null)
            {
                int count_item = listBiCan.Count;
                if (count_item > 0)
                {
                    //ddlNguoiBiKN.DataSource = listBiCan;
                    //ddlNguoiBiKN.DataTextField = "HOTEN";
                    //ddlNguoiBiKN.DataValueField = "ID";
                    //ddlNguoiBiKN.DataBind();
                    lbNguoiBiKN.DataSource = listBiCan;
                    lbNguoiBiKN.DataTextField = "HOTEN";
                    lbNguoiBiKN.DataValueField = "ID";
                    lbNguoiBiKN.DataBind();
                }
            }
            else
                lbNguoiBiKN.Items.Add(new ListItem("--- Chọn ---", "0"));
            //lbNguoiBiKN.Items[0].Selected = true;
        }
        void LoadDrop_ST_BanAn(DropDownList drop, Decimal VuAnID)
        {
            //Load số và ngày bản án để kháng cáo PAGE_KHANGCAO_ST
            PAGE_KHANGCAO_ST oBL = new PAGE_KHANGCAO_ST();
            DataTable oDT = oBL.DANHSACH_KHANGCAO_BANAN(ENUM_LOAIVUVIEC_NUMBER.AN_HINHSU, VuAnID);
            if (oDT != null)
            {
                drop.DataSource = oDT;
                drop.DataTextField = "TEN";
                drop.DataValueField = "ID";
                drop.DataBind();
            }

            drop.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
            drop.SelectedIndex = 0;
        }
        void LoadDrop_ST_QuyetDinhVuAn(DropDownList drop, Decimal VuAnID, Decimal loaiKC, bool isBiCan = true, string biCanId = null)
        {
            if (isBiCan)
            {
                if (loaiKC == 2)
                {
                    PAGE_KHANGCAO_ST oBL = new PAGE_KHANGCAO_ST();
                    DataTable oDT = oBL.DANHSACH_KHANGCAO_QUYETDINH_BICAN(ENUM_LOAIVUVIEC_NUMBER.AN_HINHSU, VuAnID, biCanId);
                    if (oDT != null)
                    {
                        drop.DataSource = oDT;
                        drop.DataTextField = "TEN";
                        drop.DataValueField = "ID";
                        drop.DataBind();
                    }
                }
            }
            else
            {

                if (loaiKC == 1)
                {
                    PAGE_KHANGCAO_ST oBL = new PAGE_KHANGCAO_ST();
                    DataTable oDT = oBL.DANHSACH_KHANGCAO_QUYETDINH(ENUM_LOAIVUVIEC_NUMBER.AN_HINHSU, VuAnID);
                    if (oDT != null)
                    {
                        drop.DataSource = oDT;
                        drop.DataTextField = "TEN";
                        drop.DataValueField = "ID";
                        drop.DataBind();
                    }
                }
                else if (loaiKC == 2)
                {
                    PAGE_KHANGCAO_ST oBL = new PAGE_KHANGCAO_ST();
                    DataTable oDT = oBL.DANHSACH_KHANGCAO_QUYETDINH_KHAC(ENUM_LOAIVUVIEC_NUMBER.AN_HINHSU, VuAnID);
                    if (oDT != null)
                    {
                        drop.DataSource = oDT;
                        drop.DataTextField = "TEN";
                        drop.DataValueField = "ID";
                        drop.DataBind();
                    }
                }
            }

            drop.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
            drop.SelectedIndex = 0;
        }
        private void LoadQD_BA_InfoKhangNghi()
        {
            if (ddlSOQDBAKhangNghi.SelectedValue == "0") return;
            decimal ID = Convert.ToDecimal(ddlSOQDBAKhangNghi.SelectedValue);

            if (rdbLoaiKN.SelectedValue == "0")
            {
                AHS_SOTHAM_BANAN oT = dt.AHS_SOTHAM_BANAN.Where(x => x.ID == ID).FirstOrDefault();
                if (oT != null)
                    txtNgayQDBA_KN.Text = string.IsNullOrEmpty(oT.NGAYBANAN + "") ? "" : ((DateTime)oT.NGAYBANAN).ToString("dd/MM/yyyy", cul);
                else txtNgayQDBA_KN.Text = "";
            }
            else if (rdbLoaiKN.SelectedValue == "2" && rdbIsQDVuAnKN.SelectedValue != "1")
            {
                AHS_SOTHAM_QUYETDINH_VUAN oT = dt.AHS_SOTHAM_QUYETDINH_VUAN.Where(x => x.ID == ID).FirstOrDefault();
                if (oT != null)
                    txtNgayQDBA_KN.Text = string.IsNullOrEmpty(oT.NGAYQD + "") ? "" : ((DateTime)oT.NGAYQD).ToString("dd/MM/yyyy", cul);
                else txtNgayQDBA_KN.Text = "";
            }
            else
            {
                AHS_SOTHAM_QUYETDINH_BICAN oT = dt.AHS_SOTHAM_QUYETDINH_BICAN.Where(x => x.ID == ID).FirstOrDefault();
                if (oT != null)
                    txtNgayQDBA_KN.Text = string.IsNullOrEmpty(oT.NGAYQD + "") ? "" : ((DateTime)oT.NGAYQD).ToString("dd/MM/yyyy", cul);
                else txtNgayQDBA_KN.Text = "";
            }

            //-------------------------------
            decimal VuAnID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");
            AHS_VUAN oVuAn = dt.AHS_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault();
            if (oVuAn != null)
            {
                DM_TOAAN oToaAn = dt.DM_TOAAN.Where(x => x.ID == oVuAn.TOAANID).FirstOrDefault();
                if (oToaAn != null)
                    txtToaAnQD_KN.Text = oToaAn.TEN;
                else txtToaAnQD_KN.Text = "";
            }
            else
                txtToaAnQD_KN.Text = "";
        }

        protected void lbtDownloadKhangNghi_Click(object sender, EventArgs e)
        {
            decimal ID = Convert.ToDecimal(hddid.Value);
            AHS_SOTHAM_KHANGNGHI oND = dt.AHS_SOTHAM_KHANGNGHI.Where(x => x.ID == ID).FirstOrDefault();
            if (oND.TENFILE != "")
            {
                var cacheKey = Guid.NewGuid().ToString("N");
                Context.Cache.Insert(key: cacheKey, value: oND.NOIDUNGFILE, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download", "window.location='" + Cls_Comon.GetRootURL_HTTPS() + "/DownloadFile.aspx?cacheKey=" + cacheKey + "&FileName=" + oND.TENFILE + "&Extension=" + oND.KIEUFILE + "';", true);
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
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "filePath", "top.$get(\"" + hddFilePath_KN.ClientID + "\").value = '" + path + "';", true);
            }
        }
        #endregion
        private void LoadCheckListYeuCau(decimal isKhangCao)
        {
            DM_DATAITEM_BL dtItemBL = new DM_DATAITEM_BL();
            if (isKhangCao == KHANGCAO)
            {
                DataTable tbl = dtItemBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.YEUCAUKCHINHSU);
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    chkYeuCauKC.DataSource = tbl;
                    chkYeuCauKC.DataTextField = "TEN";
                    chkYeuCauKC.DataValueField = "ID";
                    chkYeuCauKC.DataBind();
                }
            }
            else
            {
                DataTable tbl = dtItemBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.YEUCAUKNHINHSU);
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    chkYeuCauKN.DataSource = tbl;
                    chkYeuCauKN.DataTextField = "TEN";
                    chkYeuCauKN.DataValueField = "ID";
                    chkYeuCauKN.DataBind();
                }
            }
        }
        private void FillYeuCau(decimal ID, decimal isKhangCao)
        {
            if (isKhangCao == KHANGCAO)// Kháng cáo
            {
                List<AHS_SOTHAM_KHANGCAO_YEUCAU> lst = dt.AHS_SOTHAM_KHANGCAO_YEUCAU.Where(x => x.KHANGCAOID == ID).ToList<AHS_SOTHAM_KHANGCAO_YEUCAU>();
                if (lst != null && lst.Count > 0)
                {
                    foreach (ListItem item in chkYeuCauKC.Items)
                    {
                        item.Selected = false;
                        foreach (AHS_SOTHAM_KHANGCAO_YEUCAU obj in lst)
                        {
                            if (Convert.ToDecimal(item.Value) == obj.YEUCAUID)
                                item.Selected = true;
                        }
                    }
                }
            }
            else // Kháng nghị
            {
                List<AHS_SOTHAM_KHANGNGHI_YEUCAU> lst = dt.AHS_SOTHAM_KHANGNGHI_YEUCAU.Where(x => x.KHANGNGHIID == ID).ToList<AHS_SOTHAM_KHANGNGHI_YEUCAU>();
                if (lst != null && lst.Count > 0)
                {
                    foreach (ListItem item in chkYeuCauKN.Items)
                    {
                        item.Selected = false;
                        foreach (AHS_SOTHAM_KHANGNGHI_YEUCAU obj in lst)
                        {
                            if (Convert.ToDecimal(item.Value) == obj.YEUCAUID)
                            { item.Selected = true; }
                        }
                    }
                }
            }
        }
        private void ResetControls()
        {
            lbthongbao.Text = "";
            rdbPanelKC.Visible = rdbPanelKN.Visible = true;
            if (rdbPanelKC.SelectedValue == KHANGCAO.ToString() && rdbPanelKN.SelectedValue == KHANGCAO.ToString())//
            {
                #region Kháng cáo
                lbNguoiBiKC.ClearSelection();
                txtNgaykhangcao.Text = "";
                ddlNguoikhangcao.SelectedIndex = 0;
                rdbLoaiKC.SelectedValue = "0";
                rdbQuahan_KC.SelectedValue = "0";
                PanelIsQDVuAnKC.Visible = false;
                rdbIsQDVuAnKC.SelectedValue = "0";
                LoadQD_BAKhangCao();
                txtNoidungKC.Text = "";
                lbNguoiBiKN.SelectedIndex = -1;
                if (chkYeuCauKC.Items.Count > 0)
                {
                    foreach (ListItem item in chkYeuCauKC.Items)
                    {
                        item.Selected = false;
                    }
                }
                rdbMienAnphi.SelectedValue = "0";
                txtSobienlai.Text = "";
                txtAnphi.Text = "";
                txtNgaynopanphi.Text = "";
                hddFilePath_KC.Value = "";
                lbtDownloadKhangCao.Visible = false;
                lbtDownloadKhangCao_DonKhangCao.Visible = false;
                hddChonDonKC.Value = "";
                #endregion
            }
            else if (rdbPanelKC.SelectedValue == KHANGNGHI.ToString() && rdbPanelKN.SelectedValue == KHANGNGHI.ToString())
            {
                #region Kháng nghị
                txtSokhangnghi.Text = txtNgaykhangnghi.Text = "";
                rdbCapkhangnghi.SelectedValue = "1";
                rdbLoaiKN.SelectedValue = "0";
                PanelIsQDVuAnKN.Visible = false;
                rdbIsQDVuAnKN.SelectedValue = "0";
                LoadQD_BA_InfoKhangNghi();
                txtNoidungKN.Text = "";
                lbNguoiBiKN.SelectedIndex = -1;
                if (chkYeuCauKN.Items.Count > 0)
                {
                    foreach (ListItem item in chkYeuCauKN.Items)
                    {
                        item.Selected = false;
                    }
                }
                hddid.Value = "0";
                hddFilePath_KN.Value = "";
                lbtDownloadKhangNghi.Visible = false;
                lbtDownloadKhangNghi_DonKhangCao.Visible = false;
                hddChonDonKN.Value = "";
                #endregion
            }
            hddid.Value = "0";
            CheckQuyen();
        }
        public void LoadGrid()
        {
            AHS_SOTHAM_BL oBL = new AHS_SOTHAM_BL();
            decimal ID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");
            DataTable oDT = oBL.AHS_SOTHAM_KCaoKNghi_GETLIST(ID);
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
                        if (IsKhangCao == 1)
                        {
                            AHS_SOTHAM_KHANGCAO oKN = dt.AHS_SOTHAM_KHANGCAO.Where(x => x.ID == ID).FirstOrDefault();
                            TENFILE = oKN.TENFILE;
                            NOIDUNGFILE = oKN.NOIDUNGFILE;
                            KIEUFILE = oKN.KIEUFILE;
                        }
                        else
                        {
                            AHS_SOTHAM_KHANGNGHI oND = dt.AHS_SOTHAM_KHANGNGHI.Where(x => x.ID == ID).FirstOrDefault();
                            TENFILE = oND.TENFILE;
                            NOIDUNGFILE = oND.NOIDUNGFILE;
                            KIEUFILE = oND.KIEUFILE;
                        }

                        if (!string.IsNullOrEmpty(TENFILE))
                        {
                            var cacheKey = Guid.NewGuid().ToString("N");
                            Context.Cache.Insert(key: cacheKey, value: NOIDUNGFILE, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
                            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download", "window.location='" + Cls_Comon.GetRootURL_HTTPS() + "/DownloadFile.aspx?cacheKey=" + cacheKey + "&FileName=" + TENFILE + "&Extension=" + KIEUFILE + "';", true);
                        }
                        break;
                    case "Sua":
                        lbthongbao.Text = "";
                        LinkButton lblSua = (LinkButton)e.Item.FindControl("lblSua");
                        if (lblSua.Text == "Sửa")
                        {
                            Cls_Comon.SetButton(btnUpdate, true);
                        }
                        else
                        {
                            Cls_Comon.SetButton(btnUpdate, false);
                        }
                        LoadEdit(ID, IsKhangCao);
                        hddid.Value = ID.ToString();
                        break;
                    case "Xoa":
                        MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                        if (oPer.XOA == false)
                        {
                            lbthongbao.Text = "Bạn không có quyền xóa!";
                            return;
                        }
                        string StrMsg = "Không được sửa đổi thông tin.";
                        string Result = new AHS_CHUYEN_NHAN_AN_BL().Check_NhanAn(VuAnID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                        AHS_SOTHAM_KHANGCAO oKC = dt.AHS_SOTHAM_KHANGCAO.Where(x => x.VUANID == VuAnID && x.ID == ID).FirstOrDefault();
                        if (Result != "")
                        {
                            if (oKC.ISQUAHAN == 1)
                            {
                                //da duyet thi khong cho sua, xoa
                                //Chua duyệt thi cho sửa xóa
                                if (oKC.GQ_TINHTRANG == 1)
                                {
                                    lbthongbao.Text = Result;
                                    return;
                                }
                            }
                            //Nếu không phải quá hạn thi không cho sưa xóa
                            else
                            {
                                lbthongbao.Text = Result;
                                return;
                            }


                        }
                        xoa(ID, IsKhangCao);
                        break;
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        public void LoadEdit(decimal ID, decimal IsKhangCao)
        {
            lbthongbao.Text = "";
            rdbPanelKC.Visible = rdbPanelKN.Visible = true;
            if (IsKhangCao == KHANGCAO)// Kháng cáo
            {
                rdbPanelKC.SelectedValue = rdbPanelKN.SelectedValue = KHANGCAO.ToString();
                pnKhangCao.Visible = true;
                pnKhangNghi.Visible = false;
                AHS_SOTHAM_KHANGCAO oND = dt.AHS_SOTHAM_KHANGCAO.Where(x => x.ID == ID).FirstOrDefault();
                if (oND != null)
                {
                    hddid.Value = oND.ID.ToString();
                    //txtNgayvietdonKC.Text = string.IsNullOrEmpty(oND.NGAYVIETDON + "") ? "" : ((DateTime)oND.NGAYVIETDON).ToString("dd/MM/yyyy", cul);
                    txtNgaykhangcao.Text = string.IsNullOrEmpty(oND.NGAYKHANGCAO + "") ? "" : ((DateTime)oND.NGAYKHANGCAO).ToString("dd/MM/yyyy", cul);
                    try
                    {
                        rdbLoaiNguoiKC.SelectedValue = oND.NGUOIKCLOAI.ToString();
                        loadLoaiNguoiKC();
                        ddlNguoikhangcao.SelectedValue = oND.NGUOIKCID.ToString();
                        rdbLoaiKC.SelectedValue = oND.LOAIKHANGCAO == 3 ? "2" : oND.LOAIKHANGCAO.ToString();
                        rdbIsQDVuAnKC.SelectedValue = oND.LOAIKHANGCAO == 3 ? "1" : "0";
                        if (oND.LOAIKHANGCAO == 2 || oND.LOAIKHANGCAO == 3)
                        {
                            PanelIsQDVuAnKC.Visible = true;
                        }
                        else
                        {
                            PanelIsQDVuAnKC.Visible = true;
                        }
                    }
                    catch { }

                    if (oND.NGUOIKCLOAI.ToString() == "1")
                    {
                        plNguoiBiKC.Visible = true;
                        lbNguoiBiKC.Visible = true;
                        LoadNguoiBiKhangNghi();
                        try
                        {
                            string[] dsNguoiBiKC = oND.DSNGUOIBIKC.Split(',');
                            //foreach (var item in lbNguoiBiKC.Items)
                            //{
                            //    if (oND.DSNGUOIBIKC.Contains(item.Text))
                            //        item.Selected = true;
                            //}
                            foreach (string item in dsNguoiBiKC)
                            {
                                lbNguoiBiKC.Items.FindByValue(item).Selected = true;
                            }

                            //lbNguoiBiKC.SelectedValue = oND.NGUOIBIKC.ToString();
                        }
                        catch { }
                    }
                    if (oND.NGUOIKCLOAI.ToString() == "0")
                    {
                        plNguoiBiKC.Visible = false;
                        lbNguoiBiKC.Visible = false;
                    }
                    LoadQD_BAKhangCao();
                    try
                    {
                        ddlSOQDBA_KC.SelectedValue = oND.SOQDBA.ToString();
                        rdbQuahan_KC.SelectedValue = oND.ISQUAHAN.ToString();
                    }
                    catch { }

                    txtNgayQDBA_KC.Text = string.IsNullOrEmpty(oND.NGAYQDBA + "") ? "" : ((DateTime)oND.NGAYQDBA).ToString("dd/MM/yyyy", cul);
                    DM_TOAAN oToaAn = dt.DM_TOAAN.Where(x => x.ID == oND.TOAANRAQDID).FirstOrDefault();
                    if (oToaAn != null) { txtToaAnQD_KC.Text = oToaAn.TEN; } else { txtToaAnQD_KC.Text = ""; }
                    txtNoidungKC.Text = oND.NOIDUNGKHANGCAO;

                    if ((oND.TENFILE + "") != "")
                        lbtDownloadKhangCao.Visible = true;
                    else
                        lbtDownloadKhangCao.Visible = false;

                    FillYeuCau(ID, IsKhangCao);
                    rdbMienAnphi.SelectedValue = oND.ISMIENANPHI.ToString();
                    txtAnphi.Text = string.IsNullOrEmpty(oND.ANPHI + "") ? "" : oND.ANPHI.ToString().Equals("") ? "" : oND.ANPHI.ToString();
                    txtSobienlai.Text = oND.SOBIENLAI;
                    txtNgaynopanphi.Text = string.IsNullOrEmpty(oND.NGAYNOPANPHI + "") ? "" : ((DateTime)oND.NGAYNOPANPHI).ToString("dd/MM/yyyy", cul);
                }
            }
            else // Kháng nghị
            {
                rdbPanelKC.SelectedValue = rdbPanelKN.SelectedValue = KHANGNGHI.ToString();
                pnKhangCao.Visible = false;
                pnKhangNghi.Visible = true;
                AHS_SOTHAM_KHANGNGHI oND = dt.AHS_SOTHAM_KHANGNGHI.Where(x => x.ID == ID).FirstOrDefault();
                if (oND != null)
                {
                    hddid.Value = oND.ID.ToString();
                    try
                    {
                        rdbDonVi.SelectedValue = oND.DONVIKN.ToString();
                        rdbLoaiKN.SelectedValue = oND.LOAIKN.ToString();
                        rdbIsQDVuAnKN.SelectedValue = oND.LOAIKN == 3 ? "1" : "0";
                        //rdbIsQDVuAnKN.SelectedValue =  oND.IS_KN_BICANBICAO.ToString();
                        if (oND.LOAIKN == 2 || oND.LOAIKN == 3)
                        {
                            PanelIsQDVuAnKN.Visible = true;
                        }
                        else
                        {
                            PanelIsQDVuAnKN.Visible = true;
                        }
                    }
                    catch { }
                    txtSokhangnghi.Text = oND.SOKN;
                    txtNgaykhangnghi.Text = string.IsNullOrEmpty(oND.NGAYKN + "") ? "" : ((DateTime)oND.NGAYKN).ToString("dd/MM/yyyy", cul);
                    LoadQD_BAKhangNghi();
                    try { ddlSOQDBAKhangNghi.SelectedValue = oND.BANANID.ToString(); } catch { }
                    LoadNguoiBiKhangNghi();
                    try
                    {
                        string[] dsNguoiBiKN = oND.DSNGUOIBIKN.Split(',');
                        foreach (string item in dsNguoiBiKN)
                        {
                            if (!String.IsNullOrEmpty(item))
                                lbNguoiBiKN.Items.FindByValue(item).Selected = true;
                        }
                        //lbNguoiBiKN.SelectedValue = oND.NGUOIBIKN.ToString();
                    }
                    catch { }
                    txtNgayQDBA_KN.Text = string.IsNullOrEmpty(oND.NGAYBANAN + "") ? "" : ((DateTime)oND.NGAYBANAN).ToString("dd/MM/yyyy", cul);
                    DM_TOAAN oToaAn = dt.DM_TOAAN.Where(x => x.ID == oND.TOAANRAQDID).FirstOrDefault();
                    if (oToaAn != null)
                        txtToaAnQD_KN.Text = oToaAn.TEN;
                    else
                        txtToaAnQD_KN.Text = "";

                    txtNoidungKN.Text = oND.NOIDUNGKN;
                    if ((oND.TENFILE + "") != "")
                        lbtDownloadKhangNghi.Visible = true;
                    else
                        lbtDownloadKhangNghi.Visible = false;
                    FillYeuCau(ID, IsKhangCao);
                    rdbCapkhangnghi.Items.Clear();
                    if (rdbDonVi.SelectedValue == "0")//Chánh án
                    {
                        rdbCapkhangnghi.Items.Add(new ListItem("Cấp trên", "1"));
                        rdbCapkhangnghi.SelectedValue = "1";
                    }
                    else//Viện kiểm sát
                    {
                        rdbCapkhangnghi.Items.Add(new ListItem("Cùng cấp", "0"));
                        rdbCapkhangnghi.Items.Add(new ListItem("Cấp trên", "1"));
                        rdbCapkhangnghi.SelectedValue = "0";
                    }
                    try { rdbCapkhangnghi.SelectedValue = oND.CAPKN.ToString(); } catch { }
                    if (rdbCapkhangnghi.SelectedValue == "0")
                        trDVKN.Visible = false;
                    else
                    {
                        trDVKN.Visible = true;
                        LoadDVKN();
                       // ddlDonViKN.SelectedValue = oND.TOAAN_VKS_KN.ToString();
                        oND.TOAAN_VKS_KN = Convert.ToDecimal(ddlDonViKN.SelectedValue);
                    }
                }
            }
        }
        public void xoa(decimal ID, decimal IsKhangCao)
        {
            if (IsKhangCao == KHANGCAO)// Kháng cáo
            {
                AHS_SOTHAM_KHANGCAO oND = dt.AHS_SOTHAM_KHANGCAO.Where(x => x.ID == ID).FirstOrDefault();
                if (oND != null)
                {
                    dt.AHS_SOTHAM_KHANGCAO.Remove(oND);
                    List<AHS_SOTHAM_KHANGCAO_YEUCAU> listKcyc = dt.AHS_SOTHAM_KHANGCAO_YEUCAU.Where(x => x.KHANGCAOID == ID).ToList<AHS_SOTHAM_KHANGCAO_YEUCAU>();
                    if (listKcyc != null && listKcyc.Count > 0)
                    {
                        dt.AHS_SOTHAM_KHANGCAO_YEUCAU.RemoveRange(listKcyc);
                    }
                }
            }
            else // Kháng nghị
            {
                AHS_SOTHAM_KHANGNGHI oND = dt.AHS_SOTHAM_KHANGNGHI.Where(x => x.ID == ID).FirstOrDefault();
                if (oND != null)
                {
                    dt.AHS_SOTHAM_KHANGNGHI.Remove(oND);
                    List<AHS_SOTHAM_KHANGNGHI_YEUCAU> listKNyc = dt.AHS_SOTHAM_KHANGNGHI_YEUCAU.Where(x => x.KHANGNGHIID == ID).ToList<AHS_SOTHAM_KHANGNGHI_YEUCAU>();
                    if (listKNyc != null && listKNyc.Count > 0)
                    {
                        dt.AHS_SOTHAM_KHANGNGHI_YEUCAU.RemoveRange(listKNyc);
                    }
                }
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
                decimal ID = 0, IsKhangCao = 0, VuAnID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");
                AHS_VUAN oVuAn = dt.AHS_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault();
                if (rdbPanelKC.SelectedValue == KHANGCAO.ToString() && rdbPanelKN.SelectedValue == KHANGCAO.ToString())// Kháng cáo
                {
                    IsKhangCao = KHANGCAO;
                    if (!CheckValid(IsKhangCao)) return;
                    AHS_SOTHAM_KHANGCAO oND;
                    if (hddid.Value == "" || hddid.Value == "0")
                    {
                        oND = new AHS_SOTHAM_KHANGCAO();
                    }
                    else
                    {
                        ID = Convert.ToDecimal(hddid.Value);
                        oND = dt.AHS_SOTHAM_KHANGCAO.Where(x => x.ID == ID).FirstOrDefault();
                    }

                    if (rdbQuahan_KC.SelectedValue == "1")
                    {
                        DM_TOAAN toa = dt.DM_TOAAN.Where(x => x.ID == oVuAn.TOAANID).FirstOrDefault<DM_TOAAN>();
                        if (toa != null)
                        {
                            //Phan biet KC qua han bằng Toa cap tren khi GQ_TOAANID = ID Toa cap tren là qua han; GQ_TOAANID = null đúng han
                            oND.GQ_TOAANID = toa.CAPCHAID;
                        }
                        oND.GQ_TINHTRANG = 0;
                    }
                    else
                    {
                        oND.GQ_TOAANID = null;
                        oND.GQ_TINHTRANG = 0;
                    }

                    oND.VUANID = VuAnID;
                    oND.NGUOIKCLOAI = Convert.ToDecimal(rdbLoaiNguoiKC.SelectedValue);
                    //oND.NGAYVIETDON = (String.IsNullOrEmpty(txtNgayvietdonKC.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayvietdonKC.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    oND.NGAYKHANGCAO = (String.IsNullOrEmpty(txtNgaykhangcao.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgaykhangcao.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    oND.NGUOIKCID = Convert.ToDecimal(ddlNguoikhangcao.SelectedValue);
                    oND.LOAIKHANGCAO = rdbIsQDVuAnKC.SelectedValue == "1" ? 3 : Convert.ToDecimal(rdbLoaiKC.SelectedValue);
                    //oND.IS_KC_BICANBICAO = Convert.ToDecimal(rdbIsQDVuAnKC.SelectedValue);
                    string listNguoiBiKC = "";
                    if (lbNguoiBiKC.Items.Count > 0)
                    {
                        for (int i = 0; i < lbNguoiBiKC.Items.Count; i++)
                        {
                            if (lbNguoiBiKC.Items[i].Selected)
                            {
                                listNguoiBiKC = listNguoiBiKC + lbNguoiBiKC.Items[i].Value + ",";
                            }
                        }
                    }
                    oND.DSNGUOIBIKC = listNguoiBiKC;
                    oND.SOQDBA = Convert.ToDecimal(ddlSOQDBA_KC.SelectedValue);
                    oND.ISQUAHAN = Convert.ToDecimal(rdbQuahan_KC.SelectedValue);
                    oND.NGAYQDBA = (String.IsNullOrEmpty(txtNgayQDBA_KC.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayQDBA_KC.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    oND.TOAANRAQDID = oVuAn.TOAANID;
                    oND.NOIDUNGKHANGCAO = txtNoidungKC.Text;
                    oND.ISMIENANPHI = Convert.ToDecimal(rdbMienAnphi.SelectedValue);
                    oND.ANPHI = txtAnphi.Text == "" ? 0 : Convert.ToDecimal(txtAnphi.Text.Replace(".", ""));
                    oND.SOBIENLAI = txtSobienlai.Text;
                    oND.NGAYNOPANPHI = (String.IsNullOrEmpty(txtNgaynopanphi.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgaynopanphi.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

                   


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
                    else if (hddFilePath_KC.Value != "" && hddFilePath_KC.Value != "0")
                    {
                        decimal ID_File = Convert.ToDecimal(hddFilePath_KC.Value.ToString());
                        DON_KHAC_FILE oD_File = dt.DON_KHAC_FILE.Where(x => x.DONKHAC_ID == ID_File).FirstOrDefault();
                        if (oD_File != null)
                        {
                            oND.NOIDUNGFILE = oD_File.NOIDUNGFILE;
                            oND.TENFILE = Cls_Comon.ChuyenTVKhongDau(oD_File.TENFILE);
                            oND.KIEUFILE = oD_File.KIEUFILE;
                        }
                    }
                    oND.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    if (hddid.Value == "" || hddid.Value == "0")
                    {
                        oND.NGAYTAO = DateTime.Now;
                        oND.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";

                        oND.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                        dt.AHS_SOTHAM_KHANGCAO.Add(oND);
                    }
                    else
                    {
                        oND.NGAYSUA = DateTime.Now;
                        oND.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    }
                    dt.SaveChanges();
                    ID = oND.ID;
                }
                else if (rdbPanelKC.SelectedValue == KHANGNGHI.ToString() && rdbPanelKN.SelectedValue == KHANGNGHI.ToString())// Kháng nghị
                {
                    IsKhangCao = KHANGNGHI;
                    if (!CheckValid(IsKhangCao)) return;

                    AHS_SOTHAM_KHANGNGHI oND;
                    if (hddid.Value == "" || hddid.Value == "0")
                        oND = new AHS_SOTHAM_KHANGNGHI();
                    else
                    {
                        ID = Convert.ToDecimal(hddid.Value);
                        oND = dt.AHS_SOTHAM_KHANGNGHI.Where(x => x.ID == ID).FirstOrDefault();
                    }

                    oND.VUANID = VuAnID;
                    oND.SOKN = txtSokhangnghi.Text;
                    oND.NGAYKN = (String.IsNullOrEmpty(txtNgaykhangnghi.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgaykhangnghi.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    oND.DONVIKN = Convert.ToDecimal(rdbDonVi.SelectedValue);
                    oND.CAPKN = Convert.ToDecimal(rdbCapkhangnghi.SelectedValue);
                    oND.LOAIKN = rdbIsQDVuAnKN.SelectedValue == "1" ? 3 : Convert.ToDecimal(rdbLoaiKN.SelectedValue);
                    //oND.IS_KN_BICANBICAO = Convert.ToDecimal(rdbIsQDVuAnKN.SelectedValue);
                    oND.BANANID = Convert.ToDecimal(ddlSOQDBAKhangNghi.SelectedValue);
                    string listNguoiBiKN = "";
                    if (lbNguoiBiKC.Items.Count > 0)
                    {
                        for (int i = 0; i < lbNguoiBiKN.Items.Count; i++)
                        {
                            if (lbNguoiBiKN.Items[i].Selected)
                            {
                                listNguoiBiKN = listNguoiBiKN + lbNguoiBiKN.Items[i].Value + ",";
                            }
                        }
                    }
                    oND.DSNGUOIBIKN = listNguoiBiKN;
                    oND.NGAYBANAN = (String.IsNullOrEmpty(txtNgayQDBA_KN.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayQDBA_KN.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    oND.TOAANRAQDID = oVuAn.TOAANID;
                    oND.NOIDUNGKN = txtNoidungKN.Text;
                    if (trDVKN.Visible)
                        oND.TOAAN_VKS_KN = Convert.ToDecimal(ddlDonViKN.SelectedValue);
                    if (hddFilePath_KN.Value != "")
                    {
                        try
                        {
                            string strFilePath = hddFilePath_KN.Value.Replace("/", "\\");
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
                    else if (hddFilePath_KN.Value != "" && hddFilePath_KN.Value != "0")
                    {
                        decimal ID_File = Convert.ToDecimal(hddFilePath_KN.Value.ToString());
                        DON_KHAC_FILE oD_File = dt.DON_KHAC_FILE.Where(x => x.DONKHAC_ID == ID_File).FirstOrDefault();
                        if (oD_File != null)
                        {
                            oND.NOIDUNGFILE = oD_File.NOIDUNGFILE;
                            oND.TENFILE = Cls_Comon.ChuyenTVKhongDau(oD_File.TENFILE);
                            oND.KIEUFILE = oD_File.KIEUFILE;
                        }
                    }
                    if (hddid.Value == "" || hddid.Value == "0")
                    {
                        oND.NGAYTAO = DateTime.Now;
                        oND.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";

                        oND.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                        dt.AHS_SOTHAM_KHANGNGHI.Add(oND);
                    }
                    else
                    {
                        oND.NGAYSUA = DateTime.Now;
                        oND.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    }
                    dt.SaveChanges();
                    ID = oND.ID;
                }
                // Update yêu cầu
                UpdateYeuCau(ID, IsKhangCao);
                dgList.CurrentPageIndex = 0;
                LoadGrid();
                ResetControls();
                rdbPanelKC.Visible = rdbPanelKN.Visible = true;
                lbthongbao.Text = "Lưu thành công!";
            }
            catch (Exception ex) { lbthongbao.Text = "Lỗi: " + ex.Message; }
        }
        private bool CheckValid(decimal isKhangCao)
        {
            if (isKhangCao == KHANGCAO)// Kháng cáo
            {
                //if (txtNgayvietdonKC.Text.Trim().Length > 0 && Cls_Comon.IsValidDate(txtNgayvietdonKC.Text) == false)
                //{
                //    lbthongbao.Text = "Ngày viết đơn phải theo định dạng 'ngày/ tháng/ năm'!";
                //    txtNgayvietdonKC.Focus();
                //    return false;
                //}
                if (!checkHinhPhat())
                {
                    lbthongbao.Text = "Người dùng chưa nhập đầy đủ hình phạt cho các bị cáo!";
                    return false;
                }
                if (Cls_Comon.IsValidDate(txtNgaykhangcao.Text) == false)
                {
                    lbthongbao.Text = "Ngày kháng cáo chưa nhập hoặc không theo định dạng 'ngày/ tháng/ năm'!";
                    txtNgaykhangcao.Focus();
                    return false;
                }
                if (ddlNguoikhangcao.SelectedValue == "0")
                {
                    lbthongbao.Text = "Bạn chưa chọn người kháng cáo!";
                    ddlNguoikhangcao.Focus();
                    return false;
                }
                if (rdbLoaiKC.SelectedValue == "")
                {
                    lbthongbao.Text = "Bạn chưa chọn loại kháng cáo. Hãy kiểm tra lại!";
                    return false;
                }
                if (rdbLoaiNguoiKC.SelectedValue == "1")
                {
                    if (lbNguoiBiKC.SelectedValue == "")
                    {
                        lbthongbao.Text = "Bạn chưa chọn người bị kháng cáo. Hãy kiểm tra lại!";
                        return false;
                    }
                }
                if (ddlSOQDBA_KC.SelectedValue == "0")
                {
                    lbthongbao.Text = "Bạn chưa chọn Số QĐ/BA!";
                    ddlSOQDBA_KC.Focus();
                    return false;
                }
                if (rdbQuahan_KC.SelectedValue == "")
                {
                    lbthongbao.Text = "Mục 'Kháng cáo quá hạn' cần được chọn. Hãy kiểm tra lại!";
                    return false;
                }
                bool isSelected = false;
                foreach (ListItem item in chkYeuCauKC.Items)
                {
                    if (item.Selected)
                    {
                        isSelected = true;
                        break;
                    }
                }
                if (!isSelected)
                {
                    lbthongbao.Text = "Bạn chưa chọn yêu cầu kháng cáo!";
                    return false;
                }
                //if (rdbMienAnphi.SelectedValue == "")
                //{
                //    lbthongbao.Text = "Mục 'Miễn án phí' cần được chọn. Hãy kiểm tra lại!";
                //    return false;
                //}
                if (txtSobienlai.Text.Trim().Length > 20)
                {
                    lbthongbao.Text = "Số biên lai không quá 20 ký tự. Hãy kiểm tra lại!";
                    txtSobienlai.Focus();
                    return false;
                }
                if (txtNgaynopanphi.Text.Trim().Length > 0 && Cls_Comon.IsValidDate(txtNgaynopanphi.Text) == false)
                {
                    lbthongbao.Text = "Ngày nộp án phí phải theo định dạng 'ngày/ tháng/ năm'!";
                    txtNgaynopanphi.Focus();
                    return false;
                }
                //Kiểm tra ngày kháng cáo
                DateTime dNgayKC = (String.IsNullOrEmpty(txtNgaykhangcao.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgaykhangcao.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                if (dNgayKC > DateTime.Now)
                {
                    lbthongbao.Text = "Ngày kháng cáo không được lớn hơn ngày hiện tại !";
                    txtNgaykhangcao.Focus();
                    return false;
                }
                DateTime dNgayQDBA = (String.IsNullOrEmpty(txtNgayQDBA_KC.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayQDBA_KC.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

                if (rdbLoaiKC.SelectedValue == "0")//Bản án
                {
                    if (dNgayKC < dNgayQDBA)
                    {
                        lbthongbao.Text = "Ngày kháng cáo không được lớn hơn ngày bản án !";
                        txtNgaykhangcao.Focus();
                        return false;
                    }
                }
            }
            else// Kháng nghị
            {
                if (txtSokhangnghi.Text == "")
                {
                    lbthongbao.Text = "Bạn chưa nhập số kháng nghị!";
                    txtSokhangnghi.Focus();
                    return false;
                }
                if (Cls_Comon.IsValidDate(txtNgaykhangnghi.Text) == false)
                {
                    lbthongbao.Text = "Ngày kháng nghị chưa nhập hoặc không hợp lệ!";
                    txtNgaykhangnghi.Focus();
                    return false;
                }
                if (rdbCapkhangnghi.SelectedValue == "")
                {
                    lbthongbao.Text = "Bạn chưa chọn cấp kháng nghị!";
                    return false;
                }
                if (rdbLoaiKN.SelectedValue == "")
                {
                    lbthongbao.Text = "Bạn chưa chọn loại kháng nghị!";
                    return false;
                }
                if (ddlSOQDBAKhangNghi.SelectedValue == "0")
                {
                    lbthongbao.Text = "Chưa chọn Số QĐ/BA";
                    return false;
                }
                if (lbNguoiBiKN.SelectedValue == "")
                {
                    lbthongbao.Text = "Bạn chưa chọn người bị kháng nghị!";
                    return false;
                }
                if (txtNoidungKN.Text.Trim().Length > 1000)
                {
                    lbthongbao.Text = "Nội dung kháng nghị không quá 1000 ký tự. Hãy nhập lại!";
                    txtNoidungKN.Focus();
                    return false;
                }
                bool isSelected = false;
                foreach (ListItem item in chkYeuCauKN.Items)
                {
                    if (item.Selected)
                    {
                        isSelected = true;
                        break;
                    }
                }
                if (!isSelected)
                {
                    lbthongbao.Text = "Bạn chưa chọn yêu cầu kháng nghị!";
                    return false;
                }
            }
            return true;
        }
        private void UpdateYeuCau(decimal ID, decimal isKhangCao)
        {
            if (isKhangCao == KHANGCAO)
            {
                AHS_SOTHAM_KHANGCAO_YEUCAU obj = null;
                // lấy ra tất cả các yêu cầu cũ
                string StrKhangCaoYC = "|";
                if (ID > 0)
                {
                    List<AHS_SOTHAM_KHANGCAO_YEUCAU> lst = dt.AHS_SOTHAM_KHANGCAO_YEUCAU.Where(x => x.KHANGCAOID == ID).ToList<AHS_SOTHAM_KHANGCAO_YEUCAU>();
                    if (lst != null && lst.Count > 0)
                    {
                        foreach (AHS_SOTHAM_KHANGCAO_YEUCAU item in lst)
                            StrKhangCaoYC += item.YEUCAUID + "|";
                    }
                }
                // Phát hiện yêu cầu mới thì thêm, trùng với yêu cầu cũ thì loại khỏi danh sách
                Boolean IsNew = false;
                decimal yeuCauID = 0;
                foreach (ListItem item in chkYeuCauKC.Items)
                {
                    IsNew = false;
                    if (item.Selected)
                    {
                        if (StrKhangCaoYC == "|")
                            IsNew = true;
                        else
                        {
                            if (StrKhangCaoYC.Contains("|" + item.Value + "|"))
                            {
                                yeuCauID = Convert.ToDecimal(item.Value);
                                obj = dt.AHS_SOTHAM_KHANGCAO_YEUCAU.Where(x => x.KHANGCAOID == ID && x.YEUCAUID == yeuCauID).FirstOrDefault<AHS_SOTHAM_KHANGCAO_YEUCAU>();
                                if (obj != null)
                                {
                                    obj.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                                    obj.NGAYSUA = DateTime.Now;
                                    dt.SaveChanges();
                                }
                                StrKhangCaoYC = StrKhangCaoYC.Replace("|" + item.Value + "|", "|");
                                IsNew = false;
                            }
                            else
                                IsNew = true;
                        }
                        if (IsNew)
                        {
                            obj = new AHS_SOTHAM_KHANGCAO_YEUCAU();
                            obj.KHANGCAOID = ID;
                            obj.YEUCAUID = Convert.ToDecimal(item.Value);
                            obj.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                            obj.NGAYTAO = DateTime.Now;
                            dt.AHS_SOTHAM_KHANGCAO_YEUCAU.Add(obj);
                            dt.SaveChanges();
                        }
                    }
                }
                // yêu cầu còn lại cần phải xóa
                if (StrKhangCaoYC != "|")
                {
                    String[] arr = StrKhangCaoYC.Split('|');
                    foreach (String item in arr)
                    {
                        if (item.Length > 0)
                        {
                            yeuCauID = Convert.ToDecimal(item);
                            obj = dt.AHS_SOTHAM_KHANGCAO_YEUCAU.Where(x => x.KHANGCAOID == ID && x.YEUCAUID == yeuCauID).FirstOrDefault();
                            if (obj != null)
                            {
                                dt.AHS_SOTHAM_KHANGCAO_YEUCAU.Remove(obj);
                                dt.SaveChanges();
                            }
                        }
                    }
                }
            }
            else
            {
                AHS_SOTHAM_KHANGNGHI_YEUCAU obj = null;
                // lấy ra tất cả các yêu cầu cũ
                string StrKhangCaoYC = "|";
                if (ID > 0)
                {
                    List<AHS_SOTHAM_KHANGNGHI_YEUCAU> lst = dt.AHS_SOTHAM_KHANGNGHI_YEUCAU.Where(x => x.KHANGNGHIID == ID).ToList<AHS_SOTHAM_KHANGNGHI_YEUCAU>();
                    if (lst != null && lst.Count > 0)
                    {
                        foreach (AHS_SOTHAM_KHANGNGHI_YEUCAU item in lst)
                            StrKhangCaoYC += item.YEUCAUID + "|";
                    }
                }

                // Phát hiện yêu cầu mới thì thêm, trùng với yêu cầu cũ thì loại khỏi danh sách
                Boolean IsNew = false;
                decimal yeuCauID = 0;
                foreach (ListItem item in chkYeuCauKN.Items)
                {
                    IsNew = false;
                    if (item.Selected)
                    {
                        if (StrKhangCaoYC == "|")
                            IsNew = true;
                        else
                        {
                            if (StrKhangCaoYC.Contains("|" + item.Value + "|"))
                            {
                                yeuCauID = Convert.ToDecimal(item.Value);
                                obj = dt.AHS_SOTHAM_KHANGNGHI_YEUCAU.Where(x => x.KHANGNGHIID == ID && x.YEUCAUID == yeuCauID).FirstOrDefault<AHS_SOTHAM_KHANGNGHI_YEUCAU>();
                                if (obj != null)
                                {
                                    obj.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                                    obj.NGAYSUA = DateTime.Now;
                                    dt.SaveChanges();
                                }
                                StrKhangCaoYC = StrKhangCaoYC.Replace("|" + item.Value + "|", "|");
                                IsNew = false;
                            }
                            else
                                IsNew = true;
                        }
                        if (IsNew)
                        {
                            obj = new AHS_SOTHAM_KHANGNGHI_YEUCAU();
                            obj.KHANGNGHIID = ID;
                            obj.YEUCAUID = Convert.ToDecimal(item.Value);
                            obj.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                            obj.NGAYTAO = DateTime.Now;
                            dt.AHS_SOTHAM_KHANGNGHI_YEUCAU.Add(obj);
                            dt.SaveChanges();
                        }
                    }
                }
                // yêu cầu còn lại cần phải xóa
                if (StrKhangCaoYC != "|")
                {
                    String[] arr = StrKhangCaoYC.Split('|');
                    foreach (String item in arr)
                    {
                        if (item.Length > 0)
                        {
                            yeuCauID = Convert.ToDecimal(item);
                            obj = dt.AHS_SOTHAM_KHANGNGHI_YEUCAU.Where(x => x.KHANGNGHIID == ID && x.YEUCAUID == yeuCauID).FirstOrDefault();
                            if (obj != null)
                            {
                                dt.AHS_SOTHAM_KHANGNGHI_YEUCAU.Remove(obj);
                                dt.SaveChanges();
                            }
                        }
                    }
                }
            }
        }
        protected void rdbPanelKC_SelectedIndexChanged(object sender, EventArgs e)
        {
            lbthongbao.Text = "";
            if (rdbPanelKC.SelectedValue == KHANGCAO.ToString()) // Kháng cáo
            {
                rdbPanelKN.SelectedValue = KHANGCAO.ToString();
                pnKhangCao.Visible = true;
                pnKhangNghi.Visible = false;
            }
            else // Kháng nghị
            {
                rdbPanelKN.SelectedValue = KHANGNGHI.ToString();
                pnKhangCao.Visible = false;
                pnKhangNghi.Visible = true;

                DON_KHAC oD = dt.DON_KHAC.Where(x => x.DONID == VuAnID && x.LOAIANID == 1 && x.LOAIKCKN == 2).FirstOrDefault();
                if (oD != null)
                {
                    rdbPanelKN.SelectedValue = "2";
                    rdbPanelKC.SelectedValue = "2";
                    pnKhangCao.Visible = false;
                    pnKhangNghi.Visible = true;
                    rdbDonVi.SelectedValue = oD.NGUOIKCKN.ToString();
                    rdbLoaiKC.SelectedValue = oD.LOAIKHANGCAO.ToString();
                    rdbCapkhangnghi.Items.Clear();
                    if (rdbDonVi.SelectedValue == "0")//Chánh án
                    {
                        rdbCapkhangnghi.Items.Add(new ListItem("Cấp trên", "1"));
                        rdbCapkhangnghi.SelectedValue = "1";
                    }
                    else//Viện kiểm sát
                    {
                        rdbCapkhangnghi.Items.Add(new ListItem("Cùng cấp", "0"));
                        rdbCapkhangnghi.Items.Add(new ListItem("Cấp trên", "1"));
                        rdbCapkhangnghi.SelectedValue = "0";
                    }
                    if (rdbCapkhangnghi.SelectedValue == "0")
                    {
                        ddlDonViKN.Items.Clear();
                        decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                        List<DM_VKS> lstVKS = dt.DM_VKS.Where(x => x.TOAANID == ToaAnID).ToList();
                        if (lstVKS.Count > 0)
                        {
                            ddlDonViKN.Items.Add(new ListItem(lstVKS[0].TEN, lstVKS[0].ID.ToString()));
                        }
                        trDVKN.Visible = true;
                    }
                    else
                    {
                        trDVKN.Visible = true;
                        LoadDVKN();
                    }
                    rdbCapkhangnghi.SelectedValue = oD.CAPKHANGNGHI.ToString();
                    LoadQD_BAKhangNghi();
                    if (oD.NGAYKHANGCAO != DateTime.MinValue && oD.NGAYKHANGCAO != null) txtNgaykhangnghi.Text = ((DateTime)oD.NGAYKHANGCAO).ToString("dd/MM/yyyy", cul);
                    if (oD.SOQDBA.ToString() != null) ddlSOQDBAKhangNghi.SelectedValue = oD.SOQDBA.ToString();
                    if (oD.NGAYQDBA != DateTime.MinValue && oD.NGAYQDBA != null) txtNgayQDBA_KN.Text = ((DateTime)oD.NGAYQDBA).ToString("dd/MM/yyyy", cul);
                    DM_TOAAN toaan = dt.DM_TOAAN.Where(x => x.ID == oD.TOAANRAQDID).FirstOrDefault();
                    if (toaan != null) txtToaAnQD_KN.Text = toaan.TEN;
                    txtNoidungKN.Text = oD.NOIDUNGDON;
                    txtSokhangnghi.Text = oD.SOKHANGNGHI;
                    LoadNguoiBiKhangNghi();
                    try
                    {
                        string[] dsNguoiBiKC = oD.NGUOIBIKCKN.Split(',');

                        dsNguoiBiKC = dsNguoiBiKC.Take(dsNguoiBiKC.Length - 1).ToArray();
                        foreach (string item in dsNguoiBiKC)
                        {
                            lbNguoiBiKN.Items.FindByValue(item).Selected = true;
                        }

                        //lbNguoiBiKC.SelectedValue = oND.NGUOIBIKC.ToString();
                    }
                    catch { }

                    List<DON_KHAC_YEUCAU> lst = dt.DON_KHAC_YEUCAU.Where(x => x.DONKHACID == oD.ID).ToList<DON_KHAC_YEUCAU>();
                    if (lst != null && lst.Count > 0)
                    {
                        foreach (ListItem item in chkYeuCauKN.Items)
                        {
                            item.Selected = false;
                            foreach (DON_KHAC_YEUCAU obj in lst)
                            {
                                if (Convert.ToDecimal(item.Value) == obj.YEUCAUID)
                                    item.Selected = true;
                            }
                        }
                    }

                    DON_KHAC_FILE donkhacfile = dt.DON_KHAC_FILE.Where(x => x.DONKHAC_ID == oD.ID).FirstOrDefault();
                    if (donkhacfile != null)
                        lbtDownloadKhangNghi.Visible = true;
                    else
                        lbtDownloadKhangNghi.Visible = false;
                }
            }
        }
        protected void rdbPanelKN_SelectedIndexChanged(object sender, EventArgs e)
        {
            lbthongbao.Text = "";
            if (rdbPanelKN.SelectedValue == KHANGCAO.ToString()) // Kháng cáo
            {
                rdbPanelKC.SelectedValue = KHANGCAO.ToString();
                pnKhangCao.Visible = true;
                pnKhangNghi.Visible = false;
            }
            else // Kháng nghị
            {
                rdbPanelKC.SelectedValue = KHANGNGHI.ToString();
                pnKhangCao.Visible = false;
                pnKhangNghi.Visible = true;
            }
        }
        protected void rdbLoaiKN_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {

                if (rdbLoaiKN.SelectedValue == "2")
                {
                    PanelIsQDVuAnKN.Visible = true;
                    rdbIsQDVuAnKN.SelectedValue = "0";
                }
                else
                {
                    PanelIsQDVuAnKN.Visible = false;
                    rdbIsQDVuAnKN.SelectedValue = "0";
                }
                LoadQD_BAKhangNghi();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }

        protected void rdbDonVi_SelectedIndexChanged(object sender, EventArgs e)
        {
            rdbCapkhangnghi.Items.Clear();
            if (rdbDonVi.SelectedValue == "0")//Chánh án
            {
                rdbCapkhangnghi.Items.Add(new ListItem("Cấp trên", "1"));
                rdbCapkhangnghi.SelectedValue = "1";
            }
            else//Viện kiểm sát
            {
                rdbCapkhangnghi.Items.Add(new ListItem("Cùng cấp", "0"));
                rdbCapkhangnghi.Items.Add(new ListItem("Cấp trên", "1"));
                rdbCapkhangnghi.SelectedValue = "0";
            }
            if (rdbCapkhangnghi.SelectedValue == "0")
            {
                ddlDonViKN.Items.Clear();
                decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                List<DM_VKS> lstVKS = dt.DM_VKS.Where(x => x.TOAANID == ToaAnID).ToList();
                if (lstVKS.Count > 0)
                {
                    ddlDonViKN.Items.Add(new ListItem(lstVKS[0].TEN, lstVKS[0].ID.ToString()));
                }
                trDVKN.Visible = true;
            }
            else
            {
                trDVKN.Visible = true;
                LoadDVKN();
            }
        }


        private void LoadDVKN()
        {
            ddlDonViKN.Items.Clear();
            decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            DM_TOAAN oTA = dt.DM_TOAAN.Where(x => x.ID == ToaAnID).FirstOrDefault();
            if (rdbDonVi.SelectedValue == "0")//Tòa án
            {
                DM_TOAAN oTAP1 = dt.DM_TOAAN.Where(x => x.ID == oTA.CAPCHAID).FirstOrDefault();
                ddlDonViKN.Items.Add(new ListItem(oTAP1.TEN, oTAP1.ID.ToString()));
                if (oTAP1.CAPCHAID != 0)
                {
                    DM_TOAAN oTAP2 = dt.DM_TOAAN.Where(x => x.ID == oTAP1.CAPCHAID).FirstOrDefault();
                    ddlDonViKN.Items.Add(new ListItem(oTAP2.TEN, oTAP2.ID.ToString()));
                    if (oTAP2.CAPCHAID != 0)
                    {
                        DM_TOAAN oTAP3 = dt.DM_TOAAN.Where(x => x.ID == oTAP2.CAPCHAID).FirstOrDefault();
                        ddlDonViKN.Items.Add(new ListItem(oTAP3.TEN, oTAP3.ID.ToString()));
                    }
                }
            }
            else//Viện kiểm sát
            {
                List<DM_VKS> lstVKS = dt.DM_VKS.Where(x => x.TOAANID == ToaAnID).ToList();
                if (lstVKS.Count > 0)
                {
                    decimal IDVKS1 = (decimal)lstVKS[0].CAPCHAID;
                    DM_VKS oVKS1 = dt.DM_VKS.Where(x => x.ID == IDVKS1).FirstOrDefault();
                    ddlDonViKN.Items.Add(new ListItem(oVKS1.TEN, oVKS1.ID.ToString()));
                    if (oVKS1.CAPCHAID != 0)
                    {
                        DM_VKS oVKS2 = dt.DM_VKS.Where(x => x.ID == oVKS1.CAPCHAID).FirstOrDefault();
                        ddlDonViKN.Items.Add(new ListItem(oVKS2.TEN, oVKS2.ID.ToString()));
                        if (oVKS2.CAPCHAID != 0)
                        {
                            DM_VKS oVKS3 = dt.DM_VKS.Where(x => x.ID == oVKS2.CAPCHAID).FirstOrDefault();
                            ddlDonViKN.Items.Add(new ListItem(oVKS3.TEN, oVKS3.ID.ToString()));
                        }
                    }
                }
            }
        }
        protected void rdbCapkhangnghi_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (rdbCapkhangnghi.SelectedValue == "0")
            {
                trDVKN.Visible = false;
            }
            else
            {
                trDVKN.Visible = true;
                LoadDVKN();
            }
        }

        protected void btnLammoi_Click(object sender, EventArgs e)
        {
            ResetControls();
        }

        protected void txtNgaykhangcao_TextChanged(object sender, EventArgs e)
        {
            CheckNgayKCQuaHan();
        }

        protected void ddlNguoikhangcao_SelectedIndexChanged(object sender, EventArgs e)
        {
            string NGUOIKC = ddlNguoikhangcao.SelectedValue.ToString();
            LoadQD_BAKhangCao();
            Cls_Comon.CallFunctionJS(this, this.GetType(), "popup_loaddonkc_bc(" + VuAnID + "," + NGUOIKC + ")");
        }

        protected void cmdLoadDonKhac_Click(object sender, EventArgs e)
        {
            string keyDonID = "THONGTIN.DONKHAC.DONID" + Session[ENUM_SESSION.SESSION_USERID].ToString();
            decimal ID = Convert.ToDecimal(Session[keyDonID]);
            DON_KHAC oD = dt.DON_KHAC.Where(x => x.ID == ID && x.LOAIANID == 1 && x.LOAIKCKN == 1).FirstOrDefault();
            if (oD != null)
            {
                rdbPanelKC.SelectedValue = "1";
                rdbPanelKN.SelectedValue = "1";
                pnKhangCao.Visible = true;
                pnKhangNghi.Visible = false;
                rdbLoaiNguoiKC.SelectedValue = oD.NGUOIKCKNLOAI.ToString();
                rdbLoaiKC.SelectedValue = oD.LOAIKHANGCAO.ToString();
                ddlNguoikhangcao.SelectedValue = oD.DUONGSUID.ToString();
                if (oD.NGAYKHANGCAO != DateTime.MinValue && oD.NGAYKHANGCAO != null) txtNgaykhangcao.Text = ((DateTime)oD.NGAYKHANGCAO).ToString("dd/MM/yyyy", cul);
                rdbQuahan_KC.SelectedValue = oD.ISQUAHAN.ToString();
                LoadQD_BAKhangCao();
                if (oD.SOQDBA.ToString() != "") ddlSOQDBA_KC.SelectedValue = oD.SOQDBA.ToString();
                if (oD.NGAYQDBA != DateTime.MinValue && oD.NGAYQDBA != null) txtNgayQDBA_KN.Text = ((DateTime)oD.NGAYQDBA).ToString("dd/MM/yyyy", cul);
                DM_TOAAN toaan = dt.DM_TOAAN.Where(x => x.ID == oD.TOAANRAQDID).FirstOrDefault();
                if (toaan != null) txtToaAnQD_KC.Text = toaan.TEN;
                txtNoidungKC.Text = oD.NOIDUNGDON;

                int loai = Convert.ToInt16(rdbLoaiNguoiKC.SelectedValue);
                switch (loai)
                {
                    case 0:
                        Load_ListBiCan();
                        lbNguoiBiKC.Visible = false;
                        plNguoiBiKC.Visible = false;
                        break;
                    case 1:
                        Load_ListNguoiThamGiaToTung();
                        lbNguoiBiKC.Visible = true;
                        plNguoiBiKC.Visible = true;
                        break;
                }

                LoadNguoibiKhangCao();
                try
                {
                    string[] dsNguoiBiKC = oD.NGUOIBIKCKN.Split(',');

                    dsNguoiBiKC = dsNguoiBiKC.Take(dsNguoiBiKC.Length - 1).ToArray();

                    foreach (string item in dsNguoiBiKC)
                    {
                        lbNguoiBiKC.Items.FindByValue(item).Selected = true;
                    }

                    //lbNguoiBiKC.SelectedValue = oND.NGUOIBIKC.ToString();
                }
                catch { }

                List<DON_KHAC_YEUCAU> lst = dt.DON_KHAC_YEUCAU.Where(x => x.DONKHACID == ID).ToList<DON_KHAC_YEUCAU>();
                if (lst != null && lst.Count > 0)
                {
                    foreach (ListItem item in chkYeuCauKC.Items)
                    {
                        item.Selected = false;
                        foreach (DON_KHAC_YEUCAU obj in lst)
                        {
                            if (Convert.ToDecimal(item.Value) == obj.YEUCAUID)
                                item.Selected = true;
                        }
                    }
                }

                DON_KHAC_FILE donkhacfile = dt.DON_KHAC_FILE.Where(x => x.DONKHAC_ID == ID).FirstOrDefault();
                if (donkhacfile != null)
                    lbtDownloadKhangCao.Visible = true;
                else
                    lbtDownloadKhangCao.Visible = false;
            }
        }

        protected void lbtDownloadKhangCao_DonKhangCao_Click(object sender, EventArgs e)
        {
            decimal ID = Convert.ToDecimal(hddChonDonKC.Value);
            DON_KHAC_FILE oFile = dt.DON_KHAC_FILE.Where(x => x.DONKHAC_ID == ID).FirstOrDefault();
            if (oFile.TENFILE != "")
            {
                var cacheKey = Guid.NewGuid().ToString("N");
                Context.Cache.Insert(key: cacheKey, value: oFile.NOIDUNGFILE, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download", "window.location='" + Cls_Comon.GetRootURL_HTTPS() + "/DownloadFile.aspx?cacheKey=" + cacheKey + "&FileName=" + oFile.TENFILE + "&Extension=" + oFile.KIEUFILE + "';", true);
            }
        }

        protected void lbtDownloadKhangNghi_DonKhangCao_Click(object sender, EventArgs e)
        {
            decimal ID = Convert.ToDecimal(hddChonDonKN.Value);
            DON_KHAC_FILE oFile = dt.DON_KHAC_FILE.Where(x => x.DONKHAC_ID == ID).FirstOrDefault();
            if (oFile.TENFILE != "")
            {
                var cacheKey = Guid.NewGuid().ToString("N");
                Context.Cache.Insert(key: cacheKey, value: oFile.NOIDUNGFILE, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download", "window.location='" + Cls_Comon.GetRootURL_HTTPS() + "/DownloadFile.aspx?cacheKey=" + cacheKey + "&FileName=" + oFile.TENFILE + "&Extension=" + oFile.KIEUFILE + "';", true);
            }
        }

        void CheckNgayKCQuaHan()
        {
            int songay = 15;
            DateTime ngaysosanh = new DateTime();
            DateTime ngaykc = (String.IsNullOrEmpty(txtNgaykhangcao.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgaykhangcao.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

            Decimal banan_qd_id = Convert.ToDecimal(ddlSOQDBA_KC.SelectedValue);
            int loai_ba_qd = Convert.ToInt16(rdbLoaiKC.SelectedValue);
            //truc tiep
            if (banan_qd_id > 0)
            {
                if (loai_ba_qd == 0)
                {
                    //Khangcao ban an--> NgayQuaHan > NgayBanAn + 15 ngay
                    AHS_SOTHAM_BANAN obj = dt.AHS_SOTHAM_BANAN.Where(x => x.ID == banan_qd_id).FirstOrDefault();
                    if (obj != null)
                        ngaysosanh = Convert.ToDateTime(obj.NGAYBANAN);
                }
                else
                {
                    //khang cao quyet dinh
                    //Neu la quyet dinh đinh chi/tạm dinh chi --> songay =7
                    AHS_SOTHAM_QUYETDINH_VUAN obj = dt.AHS_SOTHAM_QUYETDINH_VUAN.Where(x => x.ID == banan_qd_id).FirstOrDefault();
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
                }
                if (ngaykc <= (ngaysosanh.AddDays(songay)))
                    rdbQuahan_KC.SelectedValue = "0";
                else
                    rdbQuahan_KC.SelectedValue = "1";
            }
        }

        //protected void ddlNguoiBiKN_SelectedIndexChanged(object sender, EventArgs e)
        //{
        //    if (lbNguoiBiKN.SelectedValue == "0") return;
        //    decimal NguoiBiKN = Convert.ToDecimal(lbNguoiBiKN.SelectedValue);
        //    AHS_SOTHAM_KHANGNGHI oVuAn = dt.AHS_SOTHAM_KHANGNGHI.Where(x => x.NGUOIBIKN == NguoiBiKN).FirstOrDefault();
        //    //Check trùng người bị kháng nghị
        //    if (oVuAn != null)
        //    {
        //        lbthongbao.Text = "Bị cáo đã bị kháng nghị!";
        //        lbNguoiBiKN.Focus();
        //        btnUpdate.Enabled = false;
        //    }
        //    else
        //    {
        //        btnUpdate.Enabled = true;
        //    }
        //}

        protected void lbNguoiBiKN_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (lbNguoiBiKN.SelectedValue == "0" || lbNguoiBiKN.SelectedValue == "") return;
            if (lbNguoiBiKN.Items.Count > 0)
            {
                for (int i = 0; i < lbNguoiBiKN.Items.Count; i++)
                {
                    if (lbNguoiBiKN.Items[i].Selected)
                    {
                        string NguoiBiKN = lbNguoiBiKN.Items[i].Value;
                        decimal hddId = Convert.ToDecimal(hddid.Value);
                        AHS_SOTHAM_KHANGNGHI oVuAn = dt.AHS_SOTHAM_KHANGNGHI.Where(x => x.DSNGUOIBIKN.Contains(NguoiBiKN) && x.ID != hddId).FirstOrDefault();
                        //Check trùng người bị kháng nghị
                        if (oVuAn != null)
                        {
                            lbthongbao.Text = "Bị cáo đã bị kháng nghị!";
                            lbNguoiBiKN.Focus();
                            btnUpdate.Enabled = false;
                        }
                        else
                        {
                            btnUpdate.Enabled = true;
                        }

                    }
                }
            }
            LoadQD_BAKhangNghi();
        }

        protected bool checkHinhPhat()
        {
            try
            {
                decimal VUANID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");
                List<AHS_BICANBICAO> LstBC = dt.AHS_BICANBICAO.Where(x => x.VUANID == VUANID).ToList(); /*Kiem tra neu chua nhap hinh phat cho bi cao thi khong cho chuyen an*/

                AHS_SOTHAM_BL oBL = new AHS_SOTHAM_BL();
                DataTable oDT = oBL.AHS_ST_BAQD_VUAN_GETLIST(VUANID);
                if (oDT == null && oDT.Rows.Count <= 0) /*Nếu có quyết định gây kết thúc thì không cần check hình phạt*/
                {
                    AHS_SOTHAM_BANAN_DIEU_CHITIET_BL objBL = new AHS_SOTHAM_BANAN_DIEU_CHITIET_BL();
                    for (int i = 0; i < LstBC.Count; i++)
                    {
                        try
                        {
                            decimal vcount = 0;
                            decimal vBicaoid = Convert.ToDecimal(LstBC[i].ID);
                            bool checkQD = true;

                            List<AHS_SOTHAM_QUYETDINH_BICAN> QDBC = dt.AHS_SOTHAM_QUYETDINH_BICAN.Where(x => x.VUANID == VUANID && x.BICANID == vBicaoid).ToList();
                            foreach (AHS_SOTHAM_QUYETDINH_BICAN qddcbc in QDBC)
                            {
                                DM_QD_QUYETDINH DMQD = dt.DM_QD_QUYETDINH.Where(x => x.ID == qddcbc.QUYETDINHID).FirstOrDefault();
                                if ((DMQD.TEN.Contains("Quyết định đình chỉ") == true) || (DMQD.TEN.Contains("Quyết định tạm đình chỉ") == true))
                                {
                                    checkQD = false;
                                }
                            }
                            if (checkQD == true)
                            {
                                List<AHS_SOTHAM_BANAN_DIEU_CHITIET> tbl = dt.AHS_SOTHAM_BANAN_DIEU_CHITIET.Where(x => x.VUANID == VUANID && x.BICANID == vBicaoid).ToList();

                                if (tbl.Count > 0)
                                {
                                    for (int j = 0; j < tbl.Count; j++)
                                    {
                                        if (tbl[j].HINHPHATID > 0)
                                            vcount++;
                                    }
                                    if (vcount == 0)
                                    {
                                        lbthongbao.Text = "Bạn chưa nhập hình phạt cho bị cáo!";
                                        return false;
                                    }

                                }
                                else
                                {
                                    lbthongbao.Text = "Bạn chưa nhập hình phạt cho bị cáo!";
                                    return false;
                                }
                            }
                        }
                        catch (Exception ex)
                        {
                            lbthongbao.Text = "Lỗi: " + ex.Message;
                            return false;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                lbthongbao.Text = "Lỗi: " + ex.Message;
            }
            return true;
        }

        protected void rdbIsQDVuAnKC_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadQD_BAKhangCao();
        }
        protected void rdbIsQDVuAnKN_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadQD_BAKhangNghi();
        }
        #region "Phân trang"
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value) - 2;
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
            LoadGrid();
        }
        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            LoadGrid();
        }
        protected void lbTLast_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = Convert.ToInt32(hddTotalPage.Value) - 1;
            hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
            LoadGrid();
        }
        protected void lbTNext_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value);
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
            LoadGrid();
        }
        protected void lbTStep_Click(object sender, EventArgs e)
        {
            LinkButton lbCurrent = (LinkButton)sender;
            dgList.CurrentPageIndex = Convert.ToInt32(lbCurrent.Text) - 1;
            hddPageIndex.Value = lbCurrent.Text;
            LoadGrid();
        }
        #endregion
    }
}