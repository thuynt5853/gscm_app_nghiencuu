using BL.GSTP;
using DAL.GSTP;
using BL.GSTP.Danhmuc;
using BL.GSTP.AHS;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BL.GSTP.GDTTT;

namespace WEB.GSTP.QLAN.GDTTT.Giaiquyet.Popup
{
    public partial class pBiCao_cc : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        String UserName = "";
        public decimal VuAnID = 0;
        public int nguoikhieunai = 2;
        public int bicao = 0;
        public int bcdauvu = 1;
        public String type = "";
        public decimal CurrNhomNSDID = 0;
        decimal don_id = 0;
        Decimal GetDonID()
        {
            string current_id = Request["hsID"] + "";
            if (current_id == "0")
            {
                don_id = Convert.ToDecimal(Session["VUVIECID_CC"] + "");
            }
            else
            {
                don_id = Convert.ToDecimal(current_id);
            }
            return don_id;
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadDropNamSinh(ddlNamsinh);
                LoadDropToiDanh(dropBiCao_ToiDanh);
                LoadDanhSachBiCao();
                GetDonID();
                if (Request["DS_ID"] + "" != "")
                {
                    LoadThongTinBC_AHS(Convert.ToDecimal(Request["DS_ID"] + ""));
                    hddBiCaoID.Value = (Request["DS_ID"] + "");
                }
            }
        }
        void LoadDropNamSinh(DropDownList ddlNamsinh)
        {
            ddlNamsinh.Items.Clear();
            int year = DateTime.Now.Year;
            for (int i = year; i >= year - 100; i--)
            {
                ListItem li = new ListItem(i.ToString());
                ddlNamsinh.Items.Add(li);
            }
            ddlNamsinh.Items.Insert(0, new ListItem("Chọn", "0"));
            //ddlNamsinh.Items.FindByText(year.ToString()).Selected = true;

        }
        protected void lkBiCao_SaveToiDanh_Click(object sender, EventArgs e)
        {
        }
        void Update_DuongSu_AnHS()
        {
            don_id = GetDonID();
            decimal DuongSuID = 0;
            //------------------------------
            DuongSuID = Convert.ToDecimal(hddBiCaoID.Value);
            GDTTT_VUAN_DUONGSU obj = dt.GDTTT_VUAN_DUONGSU.Where(x => x.ID == DuongSuID && x.VUANID == don_id).Single<GDTTT_VUAN_DUONGSU>();
            obj.NAMSINH = Convert.ToDecimal(ddlNamsinh.SelectedValue);
            if (chkBCDauVu.Checked == true)
            {//update lại các bị báo ->không phải là đầu vụ
                List<GDTTT_VUAN_DUONGSU> lst = dt.GDTTT_VUAN_DUONGSU.Where(x => x.VUANID == don_id).OrderBy(y => y.DONID).ToList();
                foreach (GDTTT_VUAN_DUONGSU its in lst)
                {
                    its.HS_BICANDAUVU = 0;
                    dt.SaveChanges();
                }
                obj.HS_BICANDAUVU = 1;
            }
            else
                obj.HS_BICANDAUVU = 0;
            obj.HS_ISBICAO = chkBiCao.Checked ? 1 : 0;
            //obj.HS_ISKHIEUNAI = chkBiCao.Checked ? 1 : 0;
            if (obj.HS_ISBICAO == 1)
            {
                obj.TENDUONGSU = txtBC_HoTen.Text.Trim();
            }
            obj.DIACHI = txtNguoiKN_DiaChi.Text;
            obj.HS_MUCAN = txtBC_MucAn.Text;
            obj.NGAYSUA = DateTime.Now;
            obj.NGUOISUA = UserName;
            dt.SaveChanges();
            lttMsgBC.Text = "Bạn đã cập nhật thành công";
        }
        void UpdateToiDanhChoDS(Decimal DuongSuID)
        {
            don_id = GetDonID();
            //------------------------------
            decimal currtoidanhId = Convert.ToDecimal(dropBiCao_ToiDanh.SelectedValue);
            List<GDTTT_VUAN_DUONGSU_TOIDANH> lst = dt.GDTTT_VUAN_DUONGSU_TOIDANH.Where(x => x.VUANID == don_id
                                                                                            && x.DUONGSUID == DuongSuID
                                                                                            && x.TOIDANHID == currtoidanhId).ToList();
            if (lst == null || lst.Count == 0)
            {
                GDTTT_VUAN_DUONGSU_TOIDANH obj = new GDTTT_VUAN_DUONGSU_TOIDANH();
                obj.DUONGSUID = DuongSuID;
                obj.VUANID = don_id;
                obj.TOIDANHID = currtoidanhId;
                obj.TENTOIDANH = dropBiCao_ToiDanh.SelectedItem.Text.Trim();
                dt.GDTTT_VUAN_DUONGSU_TOIDANH.Add(obj);
                dt.SaveChanges();
                lttMsgBC.Text = "Thêm tội danh thành công";
                //----------------
                UpdateListToiDanh_BiCao(DuongSuID);
                //-------------------
                dropBiCao_ToiDanh.SelectedIndex = 0;
                LoadDsToiDanh(DuongSuID);
            }
        }
        void UpdateListToiDanh_BiCao(Decimal DuongSuID)
        {
            don_id = Convert.ToDecimal(Session["VUVIECID_CC"] + "");
            hddVuAnID.Value = Session["VUVIECID_CC"] + "";
            // -------
            String StrToiDanh = "";

            GDTTT_VUAN_DUONGSU oBC = dt.GDTTT_VUAN_DUONGSU.Where(x => x.ID == DuongSuID).Single();
            List<GDTTT_VUAN_DUONGSU_TOIDANH> lst = dt.GDTTT_VUAN_DUONGSU_TOIDANH.Where(x => x.VUANID == don_id
                                                                                         && x.DUONGSUID == DuongSuID).ToList();
            if (lst != null && lst.Count > 0)
            {
                foreach (GDTTT_VUAN_DUONGSU_TOIDANH oTD in lst)
                {
                    StrToiDanh += (String.IsNullOrEmpty(StrToiDanh + "")) ? "" : "; ";
                    StrToiDanh += oTD.TENTOIDANH;
                }
            }
            oBC.HS_TENTOIDANH = StrToiDanh;
            dt.SaveChanges();
        }
        protected void ThemBiCao()
        {
            don_id = GetDonID();
            //------------------------------
            GDTTT_VUAN_DUONGSU obj = new GDTTT_VUAN_DUONGSU();
            obj.VUANID = don_id;
            obj.LOAI = 0;
            obj.GIOITINH = 2;
            obj.BICAOID = 0;
            obj.HS_TUCACHTOTUNG = "";
            obj.HS_BICANDAUVU = chkBCDauVu.Checked ? 1 : 0;
            obj.HS_ISBICAO = chkBiCao.Checked ? 1 : 0;
            obj.HS_ISKHIEUNAI = 0;
            obj.TUCACHTOTUNG = ENUM_DANSU_TUCACHTOTUNG.BIDON;
            obj.TENDUONGSU = Cls_Comon.FormatTenRieng(txtBC_HoTen.Text.Trim());
            obj.DIACHI = txtNguoiKN_DiaChi.Text;
            obj.NAMSINH = Convert.ToDecimal(ddlNamsinh.SelectedValue);
            obj.HS_MUCAN = txtBC_MucAn.Text;
            obj.NGAYTAO = DateTime.Now;
            obj.NGUOITAO = UserName;
            obj.NGAYSUA = DateTime.Now;
            obj.NGUOISUA = UserName;
            dt.GDTTT_VUAN_DUONGSU.Add(obj);
            dt.SaveChanges();
            lttMsgBC.Text = "Bạn đã thêm mới thành công";
            //--------------anhvh bo viec them bi cao chon duoc toi danh
            //if (dropBiCao_ToiDanh.SelectedValue != "0")
            //{
            //    GDTTT_VUAN_DUONGSU_TOIDANH obj_TD = new GDTTT_VUAN_DUONGSU_TOIDANH();
            //    obj_TD.DUONGSUID = obj.ID;
            //    obj_TD.DONID = va_cc.ID;
            //    obj_TD.TOIDANHID = Convert.ToDecimal(dropBiCao_ToiDanh.SelectedValue);
            //    obj_TD.TENTOIDANH = dropBiCao_ToiDanh.SelectedItem.Text.Trim();
            //    dt.GDTTT_VUAN_DUONGSU_TOIDANH.Add(obj_TD);
            //    dt.SaveChanges();
            //}
        }
        protected void chkBiCao_CheckedChanged(object sender, EventArgs e)
        {
            //if (chkBiCao.Checked == true)
            //{
            //    if (Session["SS_NGUOIGUI_DON"] + "" == "")
            //    {
            //        lttMsgBC.Text = "Bạn phải nhập người gửi đơn trước";
            //    }
            //    else
            //    {
            //        txtBC_HoTen.Text = Cls_Comon.FormatTenRieng((Session["SS_NGUOIGUI_DON"] + "").Trim());
            //    }
            //}
            //CheckLoaiDuongSu();
        }
        private void LoadDropToiDanh(DropDownList dropToiDanh)
        {
            string session_name = "HS_DropToiDanh";
            dropToiDanh.Items.Clear();
            GDTTT_APP_BL oBL = new GDTTT_APP_BL();
            DataTable tbl = new DataTable();
            //-------------
            tbl = oBL.DieuLuat_ToiDanh_Thongke();
            if (Session[session_name] == null)
            {
                tbl = oBL.DieuLuat_ToiDanh_Thongke();
                Session[session_name] = tbl;
            }
            else
                tbl = (DataTable)(Session[session_name]);

            dropToiDanh.DataSource = tbl;
            dropToiDanh.DataTextField = "TENTOIDANH";
            dropToiDanh.DataValueField = "ID";
            dropToiDanh.DataBind();
            dropToiDanh.Items.Insert(0, new ListItem("Chọn", "0"));
        }
        protected void cmdSaveDSHinhSu_Click(object sender, EventArgs e)
        {
            if (hddBiCaoID.Value == "")
            {
                ThemBiCao();
            }
            else if (hddBiCaoID.Value != "")
            {
                Update_DuongSu_AnHS();
                Decimal DuongSuID = Convert.ToDecimal(hddBiCaoID.Value);
                // UpdateToiDanhChoDS(DuongSuID);
            }
            LoadDanhSachBiCao();
            Cls_Comon.CallFunctionJS(this, this.GetType(), "ReloadParent();");
        }
        protected void cmdRefresh_Click(object sender, EventArgs e)
        {
            hddBiCaoID.Value = string.Empty;
            Cls_Comon.CallFunctionJS(this, this.GetType(), "ReloadParent();");
            lttMsgBC.Text = string.Empty;
        }
        protected void cmd_load_dstd_Click(object sender, EventArgs e)
        {
            LoadDanhSachBiCao();
        }
        void LoadDsToiDanh(Decimal DuongSuID)
        {
            //Decimal CurrVuAnID = (String.IsNullOrEmpty(hddVuAnID.Value)) ? 0 : Convert.ToDecimal(hddVuAnID.Value + "");
            //List<GDTTT_VUAN_DUONGSU_TOIDANH> lst = dt.GDTTT_VUAN_DUONGSU_TOIDANH.Where(x => x.VUANID == CurrVuAnID
            //                                                                             && x.DUONGSUID == DuongSuID
            //                                                                          ).ToList();
            //if (lst != null && lst.Count > 0)
            //{
            //    rptToiDanh.DataSource = lst;
            //    rptToiDanh.DataBind();
            //    rptToiDanh.Visible = true;
            //}
            //else
            //{
            //    rptToiDanh.DataSource = null;
            //    rptToiDanh.DataBind();
            //    rptToiDanh.Visible = false;
            //}
        }
        public void LoadDanhSachBiCao()
        {
            don_id = GetDonID();
            hddVuAnID.Value = Convert.ToString(GetDonID());
            Decimal CurrVuAnID = (String.IsNullOrEmpty(hddVuAnID.Value)) ? 0 : Convert.ToDecimal(hddVuAnID.Value + "");
            GDTTT_VUANVUVIEC_DUONGSU_BL objBL = new GDTTT_VUANVUVIEC_DUONGSU_BL();
            DataTable tbl = objBL.AnHS_GetAllDuongSu(don_id, "", 2);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                int count_all = Convert.ToInt32(tbl.Rows.Count);
                rptBiCao.DataSource = tbl;
                rptBiCao.DataBind();
                rptBiCao.Visible = true;
            }
            else rptBiCao.Visible = false;
        }
        protected void rptBiCao_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                String temp = "";
                DataRowView dv = (DataRowView)e.Item.DataItem;
                Repeater rptBCKN = (Repeater)e.Item.FindControl("rptBCKN");
                Literal lttBiCao = (Literal)e.Item.FindControl("lttBiCao");
                Literal lttTenDS = (Literal)e.Item.FindControl("lttTenDS");
                Control td_sua_div = e.Item.FindControl("td_sua_div");
                int is_nguoikn = Convert.ToInt16(dv["HS_IsKhieuNai"] + "");
                int is_bicao = Convert.ToInt16(dv["HS_IsBiCao"] + "");
                int is_dauvu = Convert.ToInt16(dv["HS_BiCanDauVu"] + "");
                lttTenDS.Text = dv["TenDuongSu"] + "";
                if (is_dauvu == 1)
                    lttTenDS.Text += "<span class='loaibc'>(BC đầu vụ)</span>";
                else if (is_bicao == 1 && is_nguoikn == 0)
                    lttTenDS.Text += "<span class='loaibc'>(Bị cáo)</span>";
                else if (is_bicao == 1 && is_nguoikn == 1)
                    lttTenDS.Text += "<span class='loaibc'>(Người KN là BC)</span>";
                else if (is_bicao == 0 && is_nguoikn == 1)
                    lttTenDS.Text += "<span class='loaibc'>(Người KN)</span>";
                String tentoidanh = String.IsNullOrEmpty(dv["HS_TenToiDanh"] + "") ? "" : "Tội danh:" + dv["HS_TenToiDanh"] + "";
                String muc_an = String.IsNullOrEmpty(dv["HS_MucAn"] + "") ? "" : "Mức án: " + dv["HS_MucAn"] + "";
                temp = muc_an + (String.IsNullOrEmpty(muc_an + "") ? "" : (string.IsNullOrEmpty(tentoidanh) ? "" : "</br>")) + tentoidanh;
                td_sua_div.Visible = true;
                lttBiCao.Text = temp;
                rptBCKN.Visible = true;
                lttBiCao.Visible = true;
            }
        }
        void LoadDsNguoiDuocKN(Decimal NguoiKhieuNaiID, String NoidungKN, Repeater rptBCKN, Literal lttBiCao)
        {
            //Decimal NguoiKhieuNaiID = (Convert.ToDecimal(dv["ID"] + ""));
            String temp = "";

            Decimal CurrVuAnID = (String.IsNullOrEmpty(hddVuAnID.Value)) ? 0 : Convert.ToDecimal(hddVuAnID.Value + "");
            GDTTT_VUANVUVIEC_DUONGSU_BL oBL = new GDTTT_VUANVUVIEC_DUONGSU_BL();
            try
            {
                DataTable tbl = oBL.AHS_GetBiCaoKN_ByNguoiKN(CurrVuAnID, NguoiKhieuNaiID);

                if (tbl != null && tbl.Rows.Count > 0)
                {
                    foreach (DataRow row in tbl.Rows)
                    {
                        temp = (row["BiCao_TuCachTT"] + "").Replace(", Người khiếu nại", "");
                        row["BiCao_TuCachTT"] = temp;
                    }
                    rptBCKN.Visible = true;
                    lttBiCao.Text += "<div style='float:left; width:100%; margin-bottom:3px;font-weight:bold;'> Người được khiếu nại:</div>";

                    rptBCKN.DataSource = tbl;
                    rptBCKN.DataBind();
                    //td_sua_div.Visible = false;
                }
                else
                {
                    //td_sua_div.Visible = true;
                    lttBiCao.Text = "";
                    rptBCKN.Visible = false;
                    lttBiCao.Text += (String.IsNullOrEmpty(NoidungKN) ? "" : ("</br>Khiếu nại: " + NoidungKN.ToString()));
                }
            }
            catch (Exception ex)
            {
                lttBiCao.Text += (String.IsNullOrEmpty(NoidungKN) ? "" : ("</br>Khiếu nại: " + NoidungKN.ToString()));
            }
        }
        protected void rptBiCao_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            decimal curr_id = 0;
            switch (e.CommandName)
            {
                case "Sua":
                    curr_id = Convert.ToDecimal(e.CommandArgument.ToString());
                    hddBiCaoID.Value = curr_id.ToString();
                    LoadInfoBiCao();
                    hddBiCaoDuocKN_New.Value = "0";
                    break;
                case "them_td":
                    curr_id = Convert.ToDecimal(e.CommandArgument.ToString());
                    hddBiCaoID.Value = curr_id.ToString();
                    Cls_Comon.CallFunctionJS(this, this.GetType(), "popup_them_td(" + curr_id + ");");
                    break;
                case "Xoa":
                    curr_id = Convert.ToDecimal(e.CommandArgument.ToString());
                    GDTTT_VUAN_DUONGSU oT = dt.GDTTT_VUAN_DUONGSU.Where(x => x.ID == curr_id).FirstOrDefault();
                    if (oT.HS_ISKHIEUNAI == 1)
                    {
                        lttMsgBC.Text = "Bạn không thể xóa được người khiếu nại.";
                    }
                    else
                    {
                        //Kiem tra bang Hồ sơ tử hình đã có thông tin chưa, nếu có rồi thì không cho xóa

                        //GDTTT_TUHINH_BL obl = new GDTTT_TUHINH_BL();
                        //decimal count_ds = obl.HOSO_TUHINH_BY_DUONGSUID(curr_id);
                        //if (count_ds > 0)
                        //    lttMsgBC.Text = "Bạn không được xóa Đương sự khi hồ sơ đang xem xin ân giảm";
                        //else
                        //{
                        XoaDuongSu_AnHS(curr_id);
                        //chkNguoiKhieuNai.Checked = true;
                        //ClearFormBiCao();
                        //Update_TenVuAn(null);
                        LoadDanhSachBiCao();
                        //LoadDropBiCao(false);
                        lttMsgBC.Text = "Xóa bị cáo thành công";
                        //}

                    }
                    break;
            }
        }
        void XoaDuongSu_AnHS(decimal curr_duongsu_id)
        {
            hddVuAnID.Value = Convert.ToString(GetDonID());
            if (curr_duongsu_id > 0)
            {
                GDTTT_VUAN_DUONGSU oT = dt.GDTTT_VUAN_DUONGSU.Where(x => x.ID == curr_duongsu_id).FirstOrDefault();
                if (oT != null)
                {
                    XoaAllToiDanh(curr_duongsu_id);
                    //Xoa_KN(curr_duongsu_id);
                    //------------------------------------
                    dt.GDTTT_VUAN_DUONGSU.Remove(oT);
                    dt.SaveChanges();
                }
                //------------------------------------
                // Update_TenVuAn(null);
            }
            lttMsgBC.Text = "Xóa thành công!";
        }
        void XoaAllToiDanh(Decimal DuongsuID)
        {
            hddVuAnID.Value = Convert.ToString(GetDonID());
            Decimal CurrVuAnID = (String.IsNullOrEmpty(hddVuAnID.Value)) ? 0 : Convert.ToDecimal(hddVuAnID.Value + "");
            List<GDTTT_VUAN_DUONGSU_TOIDANH> lst = dt.GDTTT_VUAN_DUONGSU_TOIDANH.Where(x => x.VUANID == CurrVuAnID && x.DUONGSUID == DuongsuID).ToList();
            if (lst != null && lst.Count > 0)
            {
                foreach (GDTTT_VUAN_DUONGSU_TOIDANH item in lst)
                    dt.GDTTT_VUAN_DUONGSU_TOIDANH.Remove(item);
            }
            dt.SaveChanges();
        }
        public void LoadInfoBiCao()
        {
            try { ClearFormBiCao(); } catch (Exception ex) { }
            decimal CurrDuongSuID = Convert.ToDecimal(hddBiCaoID.Value);
            try
            {
                LoadThongTinBC_AHS(CurrDuongSuID);
            }
            catch (Exception ex) { }
        }
        void ClearFormBiCao()
        {

        }
        void LoadThongTinBC_AHS(Decimal DuongSuID)
        {
            int is_dauvu = 0, is_bicao = 0;
            GDTTT_VUAN_DUONGSU obj = dt.GDTTT_VUAN_DUONGSU.Where(x => x.ID == DuongSuID).Single();
            if (obj != null)
            {
                is_dauvu = String.IsNullOrEmpty(obj.HS_BICANDAUVU + "") ? 0 : Convert.ToInt16(obj.HS_BICANDAUVU + "");
                is_bicao = String.IsNullOrEmpty(obj.HS_ISBICAO + "") ? 0 : Convert.ToInt16(obj.HS_ISBICAO + "");
                chkBCDauVu.Checked = is_dauvu == 1 ? true : false;
                chkBiCao.Checked = is_bicao == 1 ? true : false;
                txtBC_MucAn.Text = obj.HS_MUCAN;
                ddlNamsinh.SelectedValue = Convert.ToString(obj.NAMSINH);
                txtBC_HoTen.Text = obj.TENDUONGSU;
                txtNguoiKN_DiaChi.Text = obj.DIACHI;
                LoadDsToiDanh(obj.ID);
            }
        }
    }
}