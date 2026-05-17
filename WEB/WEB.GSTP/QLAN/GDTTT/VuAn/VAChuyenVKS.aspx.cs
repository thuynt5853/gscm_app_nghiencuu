using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using System.Data;
using System.Globalization;

using Module.Common;
using BL.GSTP;
using DAL.GSTP;
using BL.GSTP.GDTTT;
namespace WEB.GSTP.QLAN.GDTTT.VuAn
{
    public partial class VAChuyenVKS : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        Decimal PhongBanID = 0, CurrDonViID = 0, UserID = 0;
        String UserName = "";
        String SessionTTV = "GDTTT_TTV";

        protected void Page_Load(object sender, EventArgs e)
        {
            PhongBanID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_PHONGBANID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);
            CurrDonViID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_DONVIID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

            UserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            UserName = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERNAME] + "")) ? "" : (Session[ENUM_SESSION.SESSION_USERNAME] + "");

            if (UserID > 0)
            {
                if (!IsPostBack)
                {
                    LoadComponent();
                    if (Request["ID"] != null)
                    {
                        hddVuAnID.Value = Request["ID"] + "";
                        try
                        {
                            LoadInfo();
                           
                        }
                        catch (Exception ex) { }
              
                    }
                    txtSoThuLy.Focus();
                }
            }
            else Response.Redirect("/Login.aspx");
        }

        //-------------------------------------------
        void LoadComponent()
        {
            LoadDropToaAn();
            LoadLoaiAnTheoVu();
            LoadDropLanhDao();
            LoadDropTTV();
            LoadThamPhan();
            LoadDropNGuoiKy_VKS();
            hddGUID.Value = Guid.NewGuid().ToString();


            string strPBID = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
            decimal PBID = strPBID == "" ? 0 : Convert.ToDecimal(strPBID);
            DM_PHONGBAN oLoaian = dt.DM_PHONGBAN.Where(x => x.ID == PBID).FirstOrDefault();
            if (oLoaian.ISHINHSU == 1)
            {
                pnBian.Visible = true;
                pnDuongSuVuan.Visible = false;
                LoadDropNamSinh(ddlNamsinh);
                LoadDropToiDanh(dropBiCao_ToiDanh);
                LoadDanhSachBiCao();
            }
            else
            {
                pnBian.Visible = false;
                pnDuongSuVuan.Visible = true;
                LoadQHPLTK();


                LoadDsDuongSu(rptNguyenDon, ENUM_DANSU_TUCACHTOTUNG.NGUYENDON);
                LoadDsDuongSu(rptBiDon, ENUM_DANSU_TUCACHTOTUNG.BIDON);
                LoadDsDuongSu(rptDsKhac, ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ);

            }
           
            //---------------

        }
        protected void chkND_CheckedChanged(object sender, EventArgs e)
        {
            foreach (RepeaterItem item in rptNguyenDon.Items)
            {
                Panel pn = (Panel)item.FindControl("pn");
                if (chkND.Checked && pn != null)
                    pn.Visible = true;
                else pn.Visible = false;
            }
        }
        protected void lkThemND_Click(object sender, EventArgs e)
        {
            String msg_check = CheckNhapDuongSu_TheoLoai(ENUM_DANSU_TUCACHTOTUNG.NGUYENDON);
            if (!String.IsNullOrEmpty(msg_check))
            {
                lttMsg.Text = lttMsgT.Text = msg_check;
                return;
            }
            //GDTTT_VUAN obj = Update_VuAn();
            GDTTT_VUAN obj = UpdateThongTinVuAn();
            //Update duong su
            Update_DuongSu(obj, ENUM_DANSU_TUCACHTOTUNG.NGUYENDON, rptNguyenDon);
            hddSoND.Value = (Convert.ToInt32(hddSoND.Value) + 1).ToString();
            DataTable tbl = CreateTableNhapDuongSu(ENUM_DANSU_TUCACHTOTUNG.NGUYENDON);
            rptNguyenDon.DataSource = tbl;
            rptNguyenDon.DataBind();
        }

        protected void rptDuongSu_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView rowView = (DataRowView)e.Item.DataItem;
                MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                LinkButton lkXoa = (LinkButton)e.Item.FindControl("lkXoa");
                Cls_Comon.SetLinkButton(lkXoa, oPer.XOA);

                if (Convert.ToInt16(rowView["IsDelete"] + "") == 0)
                    lkXoa.Visible = false;

                try
                {
                    Panel pn = (Panel)e.Item.FindControl("pn");
                    pn.Visible = (string.IsNullOrEmpty(rowView["IsInputAddress"] + "") || Convert.ToInt16(rowView["IsInputAddress"] + "") == 0) ? false : true;

                    List<DM_HANHCHINH> lstTinhHuyen;
                    if (Session["DMTINHHUYEN"] == null)
                        lstTinhHuyen = dt.DM_HANHCHINH.OrderBy(x => x.ARRTHUTU).ToList();
                    else
                        lstTinhHuyen = (List<DM_HANHCHINH>)(Session["DMTINHHUYEN"]);
                    DropDownList ddlTinhHuyen = (DropDownList)e.Item.FindControl("ddlTinhHuyen");
                    ddlTinhHuyen.DataSource = lstTinhHuyen;
                    ddlTinhHuyen.DataTextField = "MA_TEN";
                    ddlTinhHuyen.DataValueField = "ID";
                    ddlTinhHuyen.DataBind();
                    ddlTinhHuyen.Items.Insert(0, new ListItem("Tỉnh/Huyện", "0"));
                    if (pn.Visible)
                    {
                        HiddenField hddHuyenID = (HiddenField)e.Item.FindControl("hddHuyenID");
                        string strHID = hddHuyenID.Value + "";
                        if (strHID != "")
                            ddlTinhHuyen.SelectedValue = strHID;
                    }
                }
                catch (Exception ex) { }
            }
        }
        protected void rptNguyenDon_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            decimal curr_duongsu_id = Convert.ToDecimal(e.CommandArgument.ToString());
            switch (e.CommandName)
            {
                case "Xoa":
                    Xoa_DS(curr_duongsu_id, ENUM_DANSU_TUCACHTOTUNG.NGUYENDON);
                    //LoadDsDuongSu(rptNguyenDon, ENUM_DANSU_TUCACHTOTUNG.NGUYENDON);
                    break;
            }
        }

        protected void rptBiDon_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            decimal curr_duongsu_id = Convert.ToDecimal(e.CommandArgument.ToString());
            switch (e.CommandName)
            {
                case "Xoa":
                    Xoa_DS(curr_duongsu_id, ENUM_DANSU_TUCACHTOTUNG.BIDON);
                    //LoadDsDuongSu(rptBiDon, ENUM_DANSU_TUCACHTOTUNG.BIDON);
                    break;
            }
        }

        protected void rptDsKhac_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            decimal curr_duongsu_id = Convert.ToDecimal(e.CommandArgument.ToString());
            switch (e.CommandName)
            {
                case "Xoa":
                    Xoa_DS(curr_duongsu_id, ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ);
                    //LoadDsDuongSu(rptDsKhac, ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ);
                    break;
            }
        }
        void Xoa_DS(decimal curr_duongsu_id, string tucachtt)
        {
            string temp = "";
            int count_ds = 0;
            Decimal CurrVuAnID = (String.IsNullOrEmpty(hddVuAnID.Value)) ? 0 : Convert.ToDecimal(hddVuAnID.Value + "");
            if (curr_duongsu_id > 0)
            {
                GDTTT_VUAN_DUONGSU oT = dt.GDTTT_VUAN_DUONGSU.Where(x => x.ID == curr_duongsu_id).FirstOrDefault();
                if (oT != null)
                {
                    dt.GDTTT_VUAN_DUONGSU.Remove(oT);
                    dt.SaveChanges();
                }
                //------------------------------------

                List<GDTTT_VUAN_DUONGSU> lst = dt.GDTTT_VUAN_DUONGSU.Where(x => x.VUANID == CurrVuAnID
                                                                            && x.TUCACHTOTUNG == tucachtt).ToList();
                if (lst != null && lst.Count > 0)
                {
                    count_ds = lst.Count;
                    foreach (GDTTT_VUAN_DUONGSU ds in lst)
                        temp += ((string.IsNullOrEmpty(temp + "")) ? "" : ", ") + Cls_Comon.FormatTenRieng(ds.TENDUONGSU);
                }
                //---------------------------
                GDTTT_VUAN oVA = dt.GDTTT_VUAN.Where(x => x.ID == CurrVuAnID).Single();
                if (oVA != null)
                {
                    switch (tucachtt)
                    {
                        case ENUM_DANSU_TUCACHTOTUNG.NGUYENDON:
                            oVA.NGUYENDON = temp;
                            hddSoND.Value = count_ds > 0 ? count_ds.ToString() : "1";
                            break;
                        case ENUM_DANSU_TUCACHTOTUNG.BIDON:
                            oVA.BIDON = temp;
                            hddSoBD.Value = count_ds > 0 ? count_ds.ToString() : "1";
                            break;
                        case ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ:
                            hddSoDSKhac.Value = count_ds.ToString();
                            break;
                    }

                    if (tucachtt != ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ)
                    {
                        oVA.TENVUAN = oVA.NGUYENDON + " - " + oVA.BIDON + " - " + dropQHPL.SelectedItem.Text;
                        dt.SaveChanges();
                    }
                }
            }
            else
            {
                switch (tucachtt)
                {
                    case ENUM_DANSU_TUCACHTOTUNG.NGUYENDON:
                        count_ds = (string.IsNullOrEmpty(hddSoND.Value + "")) ? 1 : Convert.ToInt16(hddSoND.Value) - 1;
                        hddSoND.Value = count_ds.ToString();
                        break;
                    case ENUM_DANSU_TUCACHTOTUNG.BIDON:
                        count_ds = (string.IsNullOrEmpty(hddSoBD.Value + "")) ? 1 : Convert.ToInt16(hddSoBD.Value) - 1;
                        hddSoBD.Value = count_ds.ToString();
                        break;
                    case ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ:
                        count_ds = (string.IsNullOrEmpty(hddSoDSKhac.Value + "")) ? 0 : Convert.ToInt16(hddSoDSKhac.Value) - 1;
                        hddSoDSKhac.Value = count_ds.ToString();
                        break;
                }
            }

            //-------------------------------
            DataTable tbl = null;
            switch (tucachtt)
            {
                case ENUM_DANSU_TUCACHTOTUNG.NGUYENDON:
                    tbl = CreateTableNhapDuongSu(ENUM_DANSU_TUCACHTOTUNG.NGUYENDON);
                    rptNguyenDon.DataSource = tbl;
                    rptNguyenDon.DataBind();
                    break;
                case ENUM_DANSU_TUCACHTOTUNG.BIDON:
                    tbl = CreateTableNhapDuongSu(ENUM_DANSU_TUCACHTOTUNG.BIDON);
                    rptBiDon.DataSource = tbl;
                    rptBiDon.DataBind();
                    break;
                case ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ:
                    tbl = CreateTableNhapDuongSu(ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ);
                    rptDsKhac.DataSource = tbl;
                    rptDsKhac.DataBind();
                    break;
            }
            lttMsg.Text = lttMsgT.Text = "Xóa thành công!";
        }

        //------------------------------
        string CheckNhapDuongSu_TheoLoai(string loai_ds)
        {
            String StrNguyenDon = "", StrBiDon = "";
            int count_item = 0;
            switch (loai_ds)
            {
                case ENUM_DANSU_TUCACHTOTUNG.NGUYENDON:
                    foreach (RepeaterItem item in rptNguyenDon.Items)
                    {
                        count_item++;
                        TextBox txtTen = (TextBox)item.FindControl("txtTen");
                        if (String.IsNullOrEmpty(txtTen.Text.Trim()))
                            StrNguyenDon += (String.IsNullOrEmpty(StrNguyenDon) ? "" : ", ") + count_item.ToString();
                    }
                    if (!String.IsNullOrEmpty(StrNguyenDon))
                        StrNguyenDon = "nguyên đơn thứ " + StrNguyenDon;
                    break;
                case ENUM_DANSU_TUCACHTOTUNG.BIDON:
                    foreach (RepeaterItem item in rptBiDon.Items)
                    {
                        count_item++;
                        TextBox txtTen = (TextBox)item.FindControl("txtTen");
                        if (String.IsNullOrEmpty(txtTen.Text.Trim()))
                            StrBiDon += (String.IsNullOrEmpty(StrBiDon) ? "" : ", ") + count_item.ToString();
                    }
                    if (!String.IsNullOrEmpty(StrBiDon))
                        StrBiDon = "bị đơn  thứ " + StrBiDon;
                    break;
                case ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ:
                    break;
            }
            //------------------------------
            String msg = "";
            if ((!String.IsNullOrEmpty(StrNguyenDon)) || (!String.IsNullOrEmpty(StrBiDon)))
            {
                msg = "Lưu ý: " + StrNguyenDon
                    + (string.IsNullOrEmpty(StrNguyenDon) ? "" : ";")
                    + StrBiDon + " chưa được nhập. Hãy kiểm tra lại!";
            }
            return msg;
        }


        //-------------------------------------------    
        protected void chkBD_CheckedChanged(object sender, EventArgs e)
        {
            foreach (RepeaterItem item in rptBiDon.Items)
            {
                Panel pn = (Panel)item.FindControl("pn");
                if (chkBD.Checked && pn != null)
                    pn.Visible = true;
                else pn.Visible = false;
            }
        }

        protected void lkThemBD_Click(object sender, EventArgs e)
        {
            String msg_check = CheckNhapDuongSu_TheoLoai(ENUM_DANSU_TUCACHTOTUNG.BIDON);
            if (!String.IsNullOrEmpty(msg_check))
            {
                lttMsg.Text = lttMsgT.Text = msg_check;
                return;
            }
            //GDTTT_VUAN obj = Update_VuAn();
            GDTTT_VUAN obj = UpdateThongTinVuAn();
            //Update duong su
            Update_DuongSu(obj, ENUM_DANSU_TUCACHTOTUNG.BIDON, rptBiDon);

            int old = Convert.ToInt32(hddSoBD.Value);
            hddSoBD.Value = (old + 1).ToString();
            DataTable tbl = CreateTableNhapDuongSu(ENUM_DANSU_TUCACHTOTUNG.BIDON);
            rptBiDon.DataSource = tbl;
            rptBiDon.DataBind();
        }
        protected void cmdLuuDS_Click(object sender, EventArgs e)
        {
            String msg_check = CheckNhapDuongSu();
            if (!String.IsNullOrEmpty(msg_check))
            {
                lttMsgT.ForeColor = lttMsg.ForeColor = System.Drawing.Color.Red;
                lttMsg.Text = lttMsgT.Text = msg_check;
                return;
            }
            //GDTTT_VUAN obj = Update_VuAn();
            GDTTT_VUAN obj = UpdateThongTinVuAn();
            //Update duong su
            if (dropLoaiAn.SelectedValue != ENUM_LOAIVUVIEC.AN_HINHSU)
            {
                Update_DuongSu(obj, ENUM_DANSU_TUCACHTOTUNG.NGUYENDON, rptNguyenDon);
                Update_DuongSu(obj, ENUM_DANSU_TUCACHTOTUNG.BIDON, rptBiDon);
                Update_DuongSu(obj, ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ, rptDsKhac);

                lblmsDuongsu.Text = "Lưu thành công Đương sự";
            }
                

        }
        string CheckNhapDuongSu()
        {
            String StrNguyenDon = "", StrBiDon = "";
            int count_item = 0;
            if (dropLoaiAn.SelectedValue != ENUM_LOAIVUVIEC.AN_HINHSU)
            {
                foreach (RepeaterItem item in rptNguyenDon.Items)
                {
                    count_item++;
                    TextBox txtTen = (TextBox)item.FindControl("txtTen");
                    if (String.IsNullOrEmpty(txtTen.Text.Trim()))
                        StrNguyenDon += (String.IsNullOrEmpty(StrNguyenDon) ? "" : ", ") + count_item.ToString();
                }
                if (!String.IsNullOrEmpty(StrNguyenDon))
                    StrNguyenDon = "nguyên đơn thứ " + StrNguyenDon;
            }
            //------------------------

            count_item = 0;
            foreach (RepeaterItem item in rptBiDon.Items)
            {
                count_item++;
                TextBox txtTen = (TextBox)item.FindControl("txtTen");
                if (String.IsNullOrEmpty(txtTen.Text.Trim()))
                    StrBiDon += (String.IsNullOrEmpty(StrBiDon) ? "" : ", ") + count_item.ToString();
            }
            if (!String.IsNullOrEmpty(StrBiDon))
                StrBiDon = "bị đơn  thứ " + StrBiDon;

            //------------------------------
            String msg = "";
            if ((!String.IsNullOrEmpty(StrNguyenDon)) || (!String.IsNullOrEmpty(StrBiDon)))
            {
                msg = "Lưu ý: " + StrNguyenDon
                    + (string.IsNullOrEmpty(StrNguyenDon) ? "" : ";")
                    + StrBiDon + " chưa được nhập. Hãy kiểm tra lại!";
            }
            return msg;
        }
        protected void chkDSKhac_CheckedChanged(object sender, EventArgs e)
        {
            foreach (RepeaterItem item in rptDsKhac.Items)
            {
                Panel pn = (Panel)item.FindControl("pn");
                if (chkDSKhac.Checked && pn != null)
                    pn.Visible = true;
                else pn.Visible = false;
            }
        }
        protected void lkThemDSKhac_Click(object sender, EventArgs e)
        {
            String msg_check = CheckNhapDuongSu_TheoLoai(ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ);
            if (!String.IsNullOrEmpty(msg_check))
            {
                lttMsg.Text = lttMsgT.Text = msg_check;
                return;
            }
            //GDTTT_VUAN obj = Update_VuAn();
            GDTTT_VUAN obj = UpdateThongTinVuAn();
            //Update duong su
            Update_DuongSu(obj, ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ, rptDsKhac);

            int old = Convert.ToInt32(hddSoDSKhac.Value);
            hddSoDSKhac.Value = (old + 1).ToString();
            DataTable tbl = CreateTableNhapDuongSu(ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ);
            rptDsKhac.DataSource = tbl;
            rptDsKhac.DataBind();
        }
        //---------------------------

        void LoadDsDuongSu(Repeater rpt, String tucachtt)
        {
            int count_all = 0, IsInputAddress = 0;

            Decimal CurrVuAnID = (String.IsNullOrEmpty(hddVuAnID.Value)) ? 0 : Convert.ToDecimal(hddVuAnID.Value + "");
            GDTTT_VUANVUVIEC_DUONGSU_BL objBL = new GDTTT_VUANVUVIEC_DUONGSU_BL();
            DataTable tbl = objBL.GetByVuAnID(CurrVuAnID, tucachtt);

            if (tbl != null && tbl.Rows.Count > 0)
            {
                count_all = tbl.Rows.Count;
                IsInputAddress = Convert.ToInt16(tbl.Rows[0]["IsInputAddress"] + "");
            }
            else
            {
                switch (tucachtt)
                {
                    case ENUM_DANSU_TUCACHTOTUNG.NGUYENDON:
                        hddSoND.Value = "1";
                        break;
                    case ENUM_DANSU_TUCACHTOTUNG.BIDON:
                        hddSoBD.Value = "1";
                        break;
                    case ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ:
                        hddSoDSKhac.Value = "0";
                        break;
                }
                tbl = CreateTableNhapDuongSu(tucachtt);
            }
            rpt.DataSource = tbl;
            rpt.DataBind();

            //--------------------
            switch (tucachtt)
            {
                case ENUM_DANSU_TUCACHTOTUNG.NGUYENDON:
                    if (count_all > 0)
                    {
                        hddSoND.Value = count_all.ToString();
                        chkND.Checked = (IsInputAddress == 0) ? false : true;
                    }
                    break;
                case ENUM_DANSU_TUCACHTOTUNG.BIDON:
                    if (count_all > 0)
                    {
                        hddSoBD.Value = count_all.ToString();
                        chkBD.Checked = (IsInputAddress == 0) ? false : true;
                    }
                    break;
                case ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ:
                    if (count_all > 0)
                    {
                        hddSoDSKhac.Value = count_all.ToString();
                        chkDSKhac.Checked = (IsInputAddress == 0) ? false : true;
                    }
                    break;
            }
        }
        DataTable CreateTableNhapDuongSu(string tucachtt)
        {
            DataTable tbl = new DataTable();
            tbl.Columns.Add("ID");
            tbl.Columns.Add("Loai", typeof(int));
            tbl.Columns.Add("TenDuongSu", typeof(string));
            tbl.Columns.Add("DiaChi", typeof(string));
            tbl.Columns.Add("HUYENID", typeof(string));
            tbl.Columns.Add("IsDelete", typeof(int));
            tbl.Columns.Add("IsInputAddress", typeof(int));

            int soluongdong = 0;
            switch (tucachtt)
            {
                case ENUM_DANSU_TUCACHTOTUNG.NGUYENDON:
                    soluongdong = Convert.ToInt16(hddSoND.Value);
                    break;
                case ENUM_DANSU_TUCACHTOTUNG.BIDON:
                    soluongdong = Convert.ToInt16(hddSoBD.Value);
                    break;
                case ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ:
                    soluongdong = Convert.ToInt16(hddSoDSKhac.Value);
                    break;
            }
            //-----------------------
            DataRow newrow = null;
            int count_item = 1;
            int IsInputAddress = 0;
            Decimal CurrVuAnID = (String.IsNullOrEmpty(hddVuAnID.Value)) ? 0 : Convert.ToDecimal(hddVuAnID.Value + "");
            if (CurrVuAnID > 0)
            {
                GDTTT_VUANVUVIEC_DUONGSU_BL objBL = new GDTTT_VUANVUVIEC_DUONGSU_BL();
                DataTable tblData = objBL.GetByVuAnID(CurrVuAnID, tucachtt);
                if (tblData != null && tblData.Rows.Count > 0)
                {
                    IsInputAddress = (string.IsNullOrEmpty(tblData.Rows[0]["IsInputAddress"] + "")) ? 0 : Convert.ToInt16(tblData.Rows[0]["IsInputAddress"] + "");
                    int count_data = tblData.Rows.Count;
                    foreach (DataRow row in tblData.Rows)
                    {
                        switch (tucachtt)
                        {
                            case ENUM_DANSU_TUCACHTOTUNG.NGUYENDON:
                                chkND.Checked = (IsInputAddress == 0) ? false : true;
                                break;
                            case ENUM_DANSU_TUCACHTOTUNG.BIDON:
                                chkBD.Checked = (IsInputAddress == 0) ? false : true;
                                break;
                            case ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ:
                                chkDSKhac.Checked = (IsInputAddress == 0) ? false : true;
                                break;
                        }
                        if (count_item <= soluongdong)
                        {
                            newrow = tbl.NewRow();
                            newrow["ID"] = row["ID"];
                            newrow["Loai"] = row["Loai"]; //ca nhan
                            newrow["TenDuongSu"] = row["TenDuongSu"];
                            newrow["DiaChi"] = row["DiaChi"];
                            newrow["HUYENID"] = row["HUYENID"] + "";
                            newrow["IsDelete"] = 1;
                            newrow["IsInputAddress"] = IsInputAddress;
                            tbl.Rows.Add(newrow);
                            count_item++;
                        }
                    }
                }
            }
            if ((count_item - 1) < soluongdong)
            {
                switch (tucachtt)
                {
                    case ENUM_DANSU_TUCACHTOTUNG.NGUYENDON:
                        IsInputAddress = (!chkND.Checked) ? 0 : 1;
                        break;
                    case ENUM_DANSU_TUCACHTOTUNG.BIDON:
                        IsInputAddress = (!chkBD.Checked) ? 0 : 1;
                        break;
                    case ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ:
                        IsInputAddress = (!chkDSKhac.Checked) ? 0 : 1;
                        break;
                }
                for (int i = count_item; i <= soluongdong; i++)
                {
                    newrow = tbl.NewRow();
                    newrow["ID"] = 0;
                    newrow["Loai"] = "0"; //ca nhan
                    newrow["TenDuongSu"] = "";
                    newrow["DiaChi"] = "";
                    newrow["HUYENID"] = 0;
                    newrow["IsDelete"] = 0;
                    newrow["IsInputAddress"] = IsInputAddress;
                    tbl.Rows.Add(newrow);
                }
            }
            return tbl;
        }
        //---------------------------
        void Update_DuongSu(GDTTT_VUAN objVA, string tucachtt, Repeater rpt)
        {
            GDTTT_VUAN_DUONGSU obj = new GDTTT_VUAN_DUONGSU();
            bool IsUpdate = false;
            Decimal CurrVuAnID = (String.IsNullOrEmpty(hddVuAnID.Value)) ? 0 : Convert.ToDecimal(hddVuAnID.Value + "");
            Decimal CurrDS = 0;
            String StrEditID = ",";
            String StrUpdate = "";
            int soluongdong = 0;
            Boolean IsNhapDiaChi = false;
            switch (tucachtt)
            {
                case ENUM_DANSU_TUCACHTOTUNG.NGUYENDON:
                    soluongdong = Convert.ToInt16(hddSoND.Value);
                    if (chkND.Checked)
                        IsNhapDiaChi = true;
                    break;
                case ENUM_DANSU_TUCACHTOTUNG.BIDON:
                    soluongdong = Convert.ToInt16(hddSoBD.Value);
                    if (chkBD.Checked)
                        IsNhapDiaChi = true;
                    break;
                case ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ:
                    soluongdong = Convert.ToInt16(hddSoDSKhac.Value);
                    if (chkDSKhac.Checked)
                        IsNhapDiaChi = true;
                    break;
            }
            int count_item = 0;
            foreach (RepeaterItem item in rpt.Items)
            {
                count_item++;
                IsUpdate = false;

                #region Update duong su
                TextBox txtTen = (TextBox)item.FindControl("txtTen");
                TextBox txtDiachi = (TextBox)item.FindControl("txtDiachi");
                if (!String.IsNullOrEmpty(txtTen.Text.Trim()))
                {
                    HiddenField hddDuongSuID = (HiddenField)item.FindControl("hddDuongSuID");
                    CurrDS = String.IsNullOrEmpty(hddDuongSuID.Value + "") ? 0 : Convert.ToDecimal(hddDuongSuID.Value);
                    if (CurrDS > 0)
                    {
                        try
                        {
                            obj = dt.GDTTT_VUAN_DUONGSU.Where(x => x.ID == CurrDS && x.VUANID == CurrVuAnID).Single<GDTTT_VUAN_DUONGSU>();
                            if (obj != null)
                                IsUpdate = true;
                            else obj = new GDTTT_VUAN_DUONGSU();
                        }
                        catch (Exception ex) { obj = new GDTTT_VUAN_DUONGSU(); }
                    }
                    else
                        obj = new GDTTT_VUAN_DUONGSU();

                    obj.VUANID = CurrVuAnID;
                    obj.LOAI = 2;// Convert.ToInt16(dropDSLoai.SelectedValue);
                    obj.TUCACHTOTUNG = tucachtt; //dropDuongSu.SelectedValue;
                    obj.TENDUONGSU = Cls_Comon.FormatTenRieng(txtTen.Text.Trim());
                    obj.GIOITINH = 2;
                    obj.ISINPUTADDRESS = (IsNhapDiaChi) ? 1 : 0;
                    if (IsNhapDiaChi)
                    {
                        obj.DIACHI = txtDiachi.Text.Trim();
                        DropDownList ddlTinhHuyen = (DropDownList)item.FindControl("ddlTinhHuyen");
                        obj.HUYENID = Convert.ToDecimal(ddlTinhHuyen.SelectedValue);
                    }
                    else
                    {
                        obj.DIACHI = "";
                        obj.HUYENID = 0;
                        obj.TINHID = 0;
                    }

                    if (!IsUpdate)
                    {
                        obj.NGAYTAO = DateTime.Now;
                        obj.NGUOITAO = UserName;
                        dt.GDTTT_VUAN_DUONGSU.Add(obj);
                        dt.SaveChanges();
                    }
                    else
                    {
                        obj.NGAYSUA = DateTime.Now;
                        obj.NGUOISUA = UserName;
                        dt.SaveChanges();
                    }
                }
                #endregion

                //-------------------------
                if (obj.ID > 0)
                {
                    StrEditID += obj.ID.ToString() + ",";
                    StrUpdate += ((string.IsNullOrEmpty(StrUpdate + "")) ? "" : ", ") + Cls_Comon.FormatTenRieng(obj.TENDUONGSU);
                }
            }

            //-------------------------
            //StrUpdate = "";
            #region Update_ListNGUyenDon_BiDon Trong GDTTT_VuAn
            if (!String.IsNullOrEmpty(StrUpdate) && tucachtt != ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ)
            {
                switch (tucachtt)
                {
                    case ENUM_DANSU_TUCACHTOTUNG.NGUYENDON:
                        objVA.NGUYENDON = StrUpdate;
                        hddSoND.Value = count_item.ToString();
                        break;
                    case ENUM_DANSU_TUCACHTOTUNG.BIDON:
                        objVA.BIDON = StrUpdate;
                        hddSoBD.Value = count_item.ToString();
                        break;
                    case ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ:
                        hddSoDSKhac.Value = count_item.ToString();
                        break;
                }
                if (tucachtt != ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ)
                {
                    objVA.TENVUAN = objVA.NGUYENDON + " - " + objVA.BIDON + " - " + dropQHPL.SelectedItem.Text;
                    dt.SaveChanges();
                }
            }
            #endregion

        }


        private void LoadQHPLTK()
        {
            dropQHPLThongKe.Items.Clear();
            string strLoaiAn = dropLoaiAn.SelectedValue;

            if (strLoaiAn == ENUM_LOAIVUVIEC.AN_HINHSU)
            {
                dropQHPLThongKe.DataSource = dt.DM_BOLUAT_TOIDANH.Where(x => x.LUATID == 5 && x.LOAI == 2).OrderBy(x => x.TENTOIDANH).ToList();
                dropQHPLThongKe.DataTextField = "TENTOIDANH";
                dropQHPLThongKe.DataValueField = "ID";
                dropQHPLThongKe.DataBind();
                dropQHPLThongKe.Items.Insert(0, new ListItem("Chọn", "0"));
                return;
            }
            List<DM_QHPL_TK> lstDM = null;
            switch (strLoaiAn)
            {
                case ENUM_LOAIVUVIEC.AN_DANSU:
                    lstDM = dt.DM_QHPL_TK.Where(x => x.STYLES == ENUM_QHPLTK.DANSU && x.ENABLE == 1).OrderBy(y => y.ARRTHUTU).ToList();
                    break;
                case ENUM_LOAIVUVIEC.AN_HANHCHINH:
                    lstDM = dt.DM_QHPL_TK.Where(x => x.STYLES == ENUM_QHPLTK.HANHCHINH && x.ENABLE == 1).OrderBy(y => y.ARRTHUTU).ToList();
                    break;
                case ENUM_LOAIVUVIEC.AN_HONNHAN_GIADINH:
                    lstDM = dt.DM_QHPL_TK.Where(x => x.STYLES == ENUM_QHPLTK.HONNHAN_GIADINH && x.ENABLE == 1).OrderBy(y => y.ARRTHUTU).ToList();
                    break;
                case ENUM_LOAIVUVIEC.AN_KINHDOANH_THUONGMAI:
                    lstDM = dt.DM_QHPL_TK.Where(x => x.STYLES == ENUM_QHPLTK.KINHDOANH_THUONGMAI && x.ENABLE == 1).OrderBy(y => y.ARRTHUTU).ToList();
                    break;
                case ENUM_LOAIVUVIEC.AN_LAODONG:
                    lstDM = dt.DM_QHPL_TK.Where(x => x.STYLES == ENUM_QHPLTK.LAODONG && x.ENABLE == 1).OrderBy(y => y.ARRTHUTU).ToList();
                    break;
                case ENUM_LOAIVUVIEC.AN_PHASAN:
                    lstDM = dt.DM_QHPL_TK.Where(x => x.STYLES == ENUM_QHPLTK.PHASAN && x.ENABLE == 1).OrderBy(y => y.ARRTHUTU).ToList();
                    break;
            }
            dropQHPLThongKe.DataSource = lstDM;
            dropQHPLThongKe.DataTextField = "CASE_NAME";
            dropQHPLThongKe.DataValueField = "ID";
            dropQHPLThongKe.DataBind();
            dropQHPLThongKe.Items.Insert(0, new ListItem("Chọn", "0"));
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
        void LoadDropNGuoiKy_VKS()
        {
            dropVKS_NguoiKy.Items.Clear();
            DM_VKS_BL objBL = new DM_VKS_BL();
            DataTable tbl = objBL.GetAll_VKS_ToiCao_CapCao();
            if (tbl != null && tbl.Rows.Count > 0)
            {
                dropVKS_NguoiKy.DataSource = tbl;
                dropVKS_NguoiKy.DataTextField = "Ten";
                dropVKS_NguoiKy.DataValueField = "ID";
                dropVKS_NguoiKy.DataBind();
            }
            dropVKS_NguoiKy.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
        }

        void LoadLoaiAnTheoVu()
        {
            int count_loaian = 0;
            dropLoaiAn.Items.Clear();
            string strPBID = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
            decimal PBID = strPBID == "" ? 0 : Convert.ToDecimal(strPBID);
            DM_PHONGBAN obj = dt.DM_PHONGBAN.Where(x => x.ID == PBID).FirstOrDefault() ?? new DM_PHONGBAN();
            if (obj.ISHINHSU == 1)
            {
                dropLoaiAn.Items.Add(new ListItem("Hình sự", ENUM_LOAIVUVIEC.AN_HINHSU));
                count_loaian++;
            }
            if (obj.ISDANSU == 1)
            {
                dropLoaiAn.Items.Add(new ListItem("Dân sự", ENUM_LOAIVUVIEC.AN_DANSU));
                count_loaian++;
            }
            if (obj.ISHANHCHINH == 1)
            {
                dropLoaiAn.Items.Add(new ListItem("Hành chính", ENUM_LOAIVUVIEC.AN_HANHCHINH));
                count_loaian++;
            }
            if (obj.ISHNGD == 1)
            {
                dropLoaiAn.Items.Add(new ListItem("Hôn nhân gia đình", ENUM_LOAIVUVIEC.AN_HONNHAN_GIADINH));
                count_loaian++;
            }
            if (obj.ISKDTM == 1)
            {
                dropLoaiAn.Items.Add(new ListItem("Kinh doanh, thương mại", ENUM_LOAIVUVIEC.AN_KINHDOANH_THUONGMAI));
                count_loaian++;
            }
            if (obj.ISLAODONG == 1)
            {
                dropLoaiAn.Items.Add(new ListItem("Lao động", ENUM_LOAIVUVIEC.AN_LAODONG));
                count_loaian++;
            }
            // if (obj.ISPHASAN == 1) ddlLoaiAn.Items.Add(new ListItem("Phá sản", ENUM_LOAIVUVIEC.AN_PHASAN));
            if (count_loaian > 1)
                dropLoaiAn.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
        }
        protected void dropLoaiAn_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadDMQuanHePL();
            LoadQHPLTK();

            SetControl_AnHinhSu();
            Cls_Comon.SetFocus(this, this.GetType(), dropQHPL.ClientID);
        }
        void SetControl_AnHinhSu()
        {
            if (dropLoaiAn.SelectedValue == ENUM_LOAIVUVIEC.AN_HINHSU)
            {
                pnBian.Visible = false;
            }
        }
        void LoadDMQuanHePL()
        {
            try
            {
                int LoaiAn = Convert.ToInt16(dropLoaiAn.SelectedValue);
                List<GDTTT_DM_QHPL> lst = dt.GDTTT_DM_QHPL.Where(x => x.LOAIAN == LoaiAn).OrderBy(y => y.TENQHPL).ToList();
                if (lst != null && lst.Count > 0)
                {
                    dropQHPL.Items.Clear();
                    dropQHPL.DataSource = lst;
                    dropQHPL.DataTextField = "TenQHPL";
                    dropQHPL.DataValueField = "ID";
                    dropQHPL.DataBind();
                    dropQHPL.Items.Insert(0, new ListItem("Chọn", "0"));
                }
            }
            catch (Exception ex) { }
        }
        //-----------------------
        //-----------------------
        void LoadDropToaAn()
        {
            dropToaAn.Items.Clear();
            DM_TOAAN_BL oTABL = new DM_TOAAN_BL();
            DataTable dtTA = oTABL.DM_TOAAN_GETBYNOTCUR(0, 0);
            dropToaAn.DataSource = dtTA;
            dropToaAn.DataTextField = "MA_TEN";
            dropToaAn.DataValueField = "ID";
            dropToaAn.DataBind();
            dropToaAn.Items.Insert(0, new ListItem("Chọn", "0"));
            //---------------------------------
            dropToaAnST.DataSource = dtTA;
            dropToaAnST.DataTextField = "MA_TEN";
            dropToaAnST.DataValueField = "ID";
            dropToaAnST.DataBind();
            dropToaAnST.Items.Insert(0, new ListItem("Chọn", "0"));
        }
        protected void dropToaAn_SelectedIndexChanged(object sender, EventArgs e)
        {
            pnAnST.Visible = false;
            hddInputAnST.Value = "0";
            decimal toa_an_id = Convert.ToDecimal(dropToaAn.SelectedValue);
            if (toa_an_id > 0)
            {
                DM_TOAAN obj = dt.DM_TOAAN.Where(x => x.ID == toa_an_id).Single();
                if (obj != null)//&& (obj.LOAITOA == "CAPCAO" || obj.LOAITOA == "CAPTINH"))
                {
                    pnAnST.Visible = true;
                    hddInputAnST.Value = "1";
                    Cls_Comon.SetFocus(this, this.GetType(), txtSoBA_ST.ClientID);
                    LoadDropToaST_TheoPT();
                }
                else { dropToaAnST.Items.Clear(); }
                string banan_pt = txtSoBA.Text.Trim();
                if (!string.IsNullOrEmpty(banan_pt)) Cls_Comon.SetFocus(this, this.GetType(), txtSoBA.ClientID);
            }
            else
            {
                pnAnST.Visible = false;
                Cls_Comon.SetFocus(this, this.GetType(), dropToaAn.ClientID);
                dropToaAnST.Items.Clear();
            }
        }
        void LoadDropToaST_TheoPT()
        {
            dropToaAnST.Items.Clear();
            DM_TOAAN_BL bl = new DM_TOAAN_BL();
            Decimal CapChaID = Convert.ToDecimal(dropToaAn.SelectedValue);
            DataTable tbl = bl.GetByCapChaID(CapChaID);
            dropToaAnST.DataSource = tbl;
            dropToaAnST.DataTextField = "MA_TEN";
            dropToaAnST.DataValueField = "ID";
            dropToaAnST.DataBind();
            dropToaAnST.Items.Insert(0, new ListItem("Chọn", "0"));
        }
        //--------------------------------
        void LoadDropLanhDao()
        {
            dropLanhDao.Items.Clear();
            DM_CANBO_BL obj = new DM_CANBO_BL();
            PhongBanID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_PHONGBANID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID] + "");

            DataTable tblLanhDao = obj.DM_CANBO_GetAllVuTruong_PVT(PhongBanID);
            if (tblLanhDao != null && tblLanhDao.Rows.Count > 0)
            {
                dropLanhDao.DataSource = tblLanhDao;
                dropLanhDao.DataValueField = "ID";
                dropLanhDao.DataTextField = "MA_TEN";
                dropLanhDao.DataBind();
                dropLanhDao.Items.Insert(0, new ListItem("Chọn", "0"));
            }
            else
                dropLanhDao.Items.Insert(0, new ListItem("Chọn", "0"));
        }
        void LoadDropTTV()
        {
            dropTTV.Items.Clear();
            DM_CANBO_BL obj = new DM_CANBO_BL();
            PhongBanID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_PHONGBANID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID] + "");

            DataTable tbl = obj.DM_CANBO_GetTTVTheoPhongBan(PhongBanID, "TTV");
            if (tbl != null && tbl.Rows.Count > 0)
            {
                dropTTV.DataSource = tbl;
                dropTTV.DataValueField = "CanBoID";
                dropTTV.DataTextField = "TenCanBo";
                dropTTV.DataBind();
                dropTTV.Items.Insert(0, new ListItem("Chọn", "0"));
            }
            else
                dropTTV.Items.Insert(0, new ListItem("Chọn", "0"));
        }
        void GetAllLanhDaoNhanBCTheoTTV(Decimal ThamTraVienID)
        {
            LoadDropLanhDao();
            PhongBanID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_PHONGBANID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID] + "");

            GDTTT_CACVU_CAUHINH_BL objBL = new GDTTT_CACVU_CAUHINH_BL();
            if (ThamTraVienID > 0)
            {
                DataTable tbl = objBL.GetLanhDaoNhanBCTheoTTV(PhongBanID, ThamTraVienID);
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    string strLDVID = tbl.Rows[0]["ID"] + "";
                    dropLanhDao.SelectedValue = strLDVID;
                }
            }
        }

        protected void dropTTV_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (dropTTV.SelectedValue != "0")
            {
                decimal thamtravien = Convert.ToDecimal(dropTTV.SelectedValue);
                GetAllLanhDaoNhanBCTheoTTV(thamtravien);
            }
            else
                LoadDropLanhDao();
            Cls_Comon.SetFocus(this, this.GetType(), dropLanhDao.ClientID);
        }
        protected void LoadThamPhan()
        {
            dropThamPhan.Items.Clear();
            Boolean IsLoadAll = false;
            decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            GDTTT_DON_BL oBL = new GDTTT_DON_BL();

            Decimal CanboID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_CANBOID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_CANBOID] + "");
            try
            {
                DM_CANBO oCB = dt.DM_CANBO.Where(x => x.ID == CanboID).Single();
                if (oCB.CHUCDANHID != null && oCB.CHUCDANHID != 0)
                {
                    DM_DATAITEM oCD = dt.DM_DATAITEM.Where(x => x.ID == oCB.CHUCDANHID).FirstOrDefault();
                    if (oCD.MA == "TPTATC")
                        dropThamPhan.Items.Add(new ListItem(oCB.HOTEN, oCB.ID.ToString()));
                    else
                        IsLoadAll = true;
                }
                else
                    IsLoadAll = true;
            }
            catch (Exception ex) { IsLoadAll = true; }

            if (IsLoadAll)
            {
                DataTable tbl = oBL.CANBO_GETBYDONVI(ToaAnID, ENUM_CHUCDANH.CHUCDANH_THAMPHAN);
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    dropThamPhan.DataSource = tbl;
                    dropThamPhan.DataValueField = "ID";
                    dropThamPhan.DataTextField = "Hoten";
                    dropThamPhan.DataBind();
                    dropThamPhan.Items.Insert(0, new ListItem("Chọn", "0"));
                }
            }
        }
        //-------------------------------------------
        void LoadInfo()
        {
            Decimal CurrDonID = (String.IsNullOrEmpty(hddVuAnID.Value)) ? 0 : Convert.ToDecimal(hddVuAnID.Value + "");
            GDTTT_VUAN obj = dt.GDTTT_VUAN.Where(x => x.ID == CurrDonID).Single();
            if (obj != null)
            {
                //----thong tin thu ly-----------------
                txtSoThuLy.Text = obj.SOTHULYDON + "";
                txtNgayThuLy.Text = (String.IsNullOrEmpty(obj.NGAYTHULYDON + "") || (obj.NGAYTHULYDON == DateTime.MinValue)) ? "" : ((DateTime)obj.NGAYTHULYDON).ToString("dd/MM/yyyy", cul);
                //txtNguoiDeNghi.Text = obj.NGUOIKHIEUNAI + "";
                //txtNgayTrongDon.Text = (String.IsNullOrEmpty(obj.NGAYTRONGDON + "") || (obj.NGAYTRONGDON == DateTime.MinValue)) ? "" : ((DateTime)obj.NGAYTRONGDON).ToString("dd/MM/yyyy", cul);
                //txtNgayNhanDon.Text = (String.IsNullOrEmpty(obj.NGAYNHANDONDENGHI + "") || (obj.NGAYNHANDONDENGHI == DateTime.MinValue)) ? "" : ((DateTime)obj.NGAYNHANDONDENGHI).ToString("dd/MM/yyyy", cul);
                //txtNguoiDeNghi_DiaChi.Text = obj.DIACHINGUOIDENGHI;

                //---------thong tin BA/QD----------------------
              
                try { Cls_Comon.SetValueComboBox(dropToaAn, obj.TOAPHUCTHAMID); } catch (Exception ex) { }
                txtSoBA.Text = obj.SOANPHUCTHAM + "";
                txtNgayBA.Text = (String.IsNullOrEmpty(obj.NGAYXUPHUCTHAM + "") || (obj.NGAYXUPHUCTHAM == DateTime.MinValue)) ? "" : ((DateTime)obj.NGAYXUPHUCTHAM).ToString("dd/MM/yyyy", cul);

                pnAnST.Visible = false;
                DM_TOAAN objTA = dt.DM_TOAAN.Where(x => x.ID == obj.TOAPHUCTHAMID).Single();
                if (objTA != null)
                {
                    if (objTA.LOAITOA == "CAPCAO")
                    {
                        pnAnST.Visible = true;
                        //hddInputAnST.Value = "1";
                        try { Cls_Comon.SetValueComboBox(dropToaAnST, obj.TOAANSOTHAM); } catch (Exception ex) { }
                        txtSoBA_ST.Text = obj.SOANSOTHAM + "";
                        txtNgayBA_ST.Text = (String.IsNullOrEmpty(obj.NGAYXUSOTHAM + "") || (obj.NGAYXUSOTHAM == DateTime.MinValue)) ? "" : ((DateTime)obj.NGAYXUSOTHAM).ToString("dd/MM/yyyy", cul);
                    }
                }


                //----------thong tin TTV/LD---------------------
                txtNgayphancong.Text = (String.IsNullOrEmpty(obj.NGAYPHANCONGTTV + "") || (obj.NGAYPHANCONGTTV == DateTime.MinValue)) ? "" : ((DateTime)obj.NGAYPHANCONGTTV).ToString("dd/MM/yyyy", cul);
                decimal thamtravien = (String.IsNullOrEmpty(obj.THAMTRAVIENID + "")) ? 0 : Convert.ToDecimal(obj.THAMTRAVIENID);
                try { Cls_Comon.SetValueComboBox(dropTTV, thamtravien); } catch (Exception ex) { }
                if (thamtravien > 0)
                    GetAllLanhDaoNhanBCTheoTTV(thamtravien);

                try { Cls_Comon.SetValueComboBox(dropLanhDao, obj.LANHDAOVUID); } catch (Exception ex) { }
                try { Cls_Comon.SetValueComboBox(dropThamPhan, obj.THAMPHANID); } catch (Exception ex) { }
                txtNgayNhanTieuHS.Text = (String.IsNullOrEmpty(obj.NGAYTTVNHAN_THS + "") || (obj.NGAYTTVNHAN_THS == DateTime.MinValue)) ? "" : ((DateTime)obj.NGAYTTVNHAN_THS).ToString("dd/MM/yyyy", cul);
                txtNgayGDNhanHS.Text = (String.IsNullOrEmpty(obj.NGAYVUGDNHAN_THS + "") || (obj.NGAYVUGDNHAN_THS == DateTime.MinValue)) ? "" : ((DateTime)obj.NGAYVUGDNHAN_THS).ToString("dd/MM/yyyy", cul);
                txtGhiChu.Text = obj.GHICHU;

                //---------------------------
                LoadThongTin_VA_XXGDTTT(obj);
            }
        }

        void LoadThongTin_VA_XXGDTTT(GDTTT_VUAN oVA)
        {
            int IsVienTruongKN = string.IsNullOrEmpty(oVA.ISVIENTRUONGKN + "") ? 0 : (int)oVA.ISVIENTRUONGKN;
            if (IsVienTruongKN == 1)
            {
                pnHoSoVKS.Visible = true;
                txtVKS_So.Text = oVA.VIENTRUONGKN_SO + "";
                txtVKS_Ngay.Text = (String.IsNullOrEmpty(oVA.VIENTRUONGKN_NGAY + "") || (oVA.VIENTRUONGKN_NGAY == DateTime.MinValue)) ? "" : ((DateTime)oVA.VIENTRUONGKN_NGAY).ToString("dd/MM/yyyy", cul);
                Cls_Comon.SetValueComboBox(dropVKS_NguoiKy, oVA.VIENTRUONGKN_NGUOIKY);
            }
            else
            {
                pnHoSoVKS.Visible = false;
            }

            //----Thong tin thu ly xet xu GDT----------
            txtSoThuLy.Text = oVA.SOTHULYXXGDT + "";
            txtNgayThuLy.Text = (String.IsNullOrEmpty(oVA.NGAYTHULYXXGDT + "") || (oVA.NGAYTHULYXXGDT == DateTime.MinValue)) ? "" : ((DateTime)oVA.NGAYTHULYXXGDT).ToString("dd/MM/yyyy", cul);
            txtNgayVKSTraHS.Text = (String.IsNullOrEmpty(oVA.XXGDTTT_NGAYVKSTRAHS + "") || (oVA.XXGDTTT_NGAYVKSTRAHS == DateTime.MinValue)) ? "" : ((DateTime)oVA.XXGDTTT_NGAYVKSTRAHS).ToString("dd/MM/yyyy", cul);

            //----Ket qua XX GDTTT-----------------------
            //txtSoQD.Text = oVA.XXGDTTT_SOQD + "";
            //txtNgayQD.Text = (String.IsNullOrEmpty(oVA.XXGDTTT_NGAYQD + "") || (oVA.XXGDTTT_NGAYQD == DateTime.MinValue)) ? "" : ((DateTime)oVA.XXGDTTT_NGAYQD).ToString("dd/MM/yyyy", cul);
            //if (!string.IsNullOrEmpty(oVA.XXGDTTT_SOQD + ""))
            //    txtSoQD.Enabled = false;
            //if (!string.IsNullOrEmpty(oVA.XXGDTTT_NGAYQD + ""))
            //    txtNgayQD.Enabled = false;
            //txtHoan_NgayMoPT.Text = (String.IsNullOrEmpty(oVA.XXGDTTT_NGAYVKSTRAHS + "") || (oVA.XXGDTTT_NGAYVKSTRAHS == DateTime.MinValue)) ? "" : ((DateTime)oVA.XXGDTTT_NGAYVKSTRAHS).ToString("dd/MM/yyyy", cul);
        }
        //----------------------------------------
        protected void cmdUpdate_Click(object sender, EventArgs e)
        {
            GDTTT_VUAN obj = UpdateThongTinVuAn();
            lttMsgT.ForeColor = lttMsg.ForeColor = System.Drawing.Color.Blue;
            lttMsgT.Text = lttMsg.Text = "Tạo vụ án thành công!";
        }
        GDTTT_VUAN UpdateThongTinVuAn()
        {
            GDTTT_VUAN obj = new GDTTT_VUAN();
            bool IsUpdate = false;
            Decimal UserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            String UserName = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERNAME] + "")) ? "" : (Session[ENUM_SESSION.SESSION_USERNAME] + "");
            Decimal CurrDonID = (String.IsNullOrEmpty(hddVuAnID.Value)) ? 0 : Convert.ToDecimal(hddVuAnID.Value + "");

            if (CurrDonID > 0)
            {
                try
                {
                    obj = dt.GDTTT_VUAN.Where(x => x.ID == CurrDonID).Single<GDTTT_VUAN>();
                    if (obj != null)
                        IsUpdate = true;
                    else
                        obj = new GDTTT_VUAN();
                }
                catch (Exception ex) { obj = new GDTTT_VUAN(); }
            }
            else
                obj = new GDTTT_VUAN();

            obj.PHONGBANID = PhongBanID;
            obj.TOAANID = CurrDonViID;
           
            //------Thong tin BA/QD------------------
            obj.LOAIAN = Convert.ToDecimal(dropLoaiAn.SelectedValue);
            if (pnPhucTham.Visible)
            {
                obj.SOANPHUCTHAM = txtSoBA.Text.Trim();
                obj.NGAYXUPHUCTHAM = (String.IsNullOrEmpty(txtNgayBA.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayBA.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                obj.TOAPHUCTHAMID = Convert.ToDecimal(dropToaAn.SelectedValue);
            }

            
            if (pnAnST.Visible)
            {
                obj.SOANSOTHAM = txtSoBA_ST.Text.Trim();
                
                if (!String.IsNullOrEmpty(txtNgayBA_ST.Text.Trim()))
                    obj.NGAYXUSOTHAM = (String.IsNullOrEmpty(txtNgayBA_ST.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayBA_ST.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                if (Convert.ToDecimal(dropToaAnST.SelectedValue) > 0)
                    obj.TOAANSOTHAM = Convert.ToDecimal(dropToaAnST.SelectedValue);
            }

            //-----Thong tin TTV/LD------------------------
            DateTime date_temp;
            if (!String.IsNullOrEmpty(txtNgayphancong.Text.Trim()))
            {
                date_temp = (String.IsNullOrEmpty(txtNgayphancong.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayphancong.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                obj.NGAYPHANCONGTTV = date_temp;
            }
          
            if (Convert.ToDecimal(dropTTV.SelectedValue) > 0)
            {
                obj.THAMTRAVIENID = Convert.ToDecimal(dropTTV.SelectedValue);
                obj.TENTHAMTRAVIEN = (dropTTV.SelectedValue == "0") ? "" : Cls_Comon.FormatTenRieng(dropTTV.SelectedItem.Text);
            }

                

            if (!String.IsNullOrEmpty(txtNgayNhanTieuHS.Text.Trim()))
            {
                date_temp = (String.IsNullOrEmpty(txtNgayNhanTieuHS.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayNhanTieuHS.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                obj.NGAYTTVNHAN_THS = date_temp;
            }
            if (Convert.ToDecimal(dropLanhDao.SelectedValue) > 0)
                obj.LANHDAOVUID = Convert.ToDecimal(dropLanhDao.SelectedValue);
            if (!String.IsNullOrEmpty(txtNgayGDNhanHS.Text.Trim()))
            {
                date_temp = (String.IsNullOrEmpty(txtNgayGDNhanHS.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayGDNhanHS.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                obj.NGAYVUGDNHAN_THS = date_temp;     
            }
            if (Convert.ToDecimal(dropThamPhan.SelectedValue) > 0)
                obj.THAMPHANID = Convert.ToDecimal(dropThamPhan.SelectedValue);
            if (!String.IsNullOrEmpty(txtGhiChu.Text.Trim()))
                obj.GHICHU = txtGhiChu.Text.Trim();

            //---------------------------------
            if (dropLoaiAn.SelectedValue != ENUM_LOAIVUVIEC.AN_HINHSU)
            {
                obj.QHPL_DINHNGHIAID = Convert.ToDecimal(dropQHPL.SelectedValue);
                obj.QHPL_THONGKEID = Convert.ToDecimal(dropQHPLThongKe.SelectedValue);
            }
                

            obj.ISVIENTRUONGKN = 1;
            //-Thong tin KN của VKS---------
            if (!String.IsNullOrEmpty(txtVKS_Ngay.Text.Trim()))
            {
                date_temp = (String.IsNullOrEmpty(txtVKS_Ngay.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(txtVKS_Ngay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                obj.VIENTRUONGKN_NGAY = date_temp;
            }
            if (!String.IsNullOrEmpty(txtVKS_So.Text.Trim()))
                obj.VIENTRUONGKN_SO = txtVKS_So.Text;

                obj.VIENTRUONGKN_NGUOIKY = Convert.ToDecimal(dropVKS_NguoiKy.SelectedValue);

            //-----Thong tin ThuLy xet xu  GDT-------------------
            if (!String.IsNullOrEmpty(txtSoThuLy.Text.Trim()))
                obj.SOTHULYXXGDT = txtSoThuLy.Text.Trim();
            if (!String.IsNullOrEmpty(txtNgayThuLy.Text.Trim()))
            {
                date_temp = (String.IsNullOrEmpty(txtNgayThuLy.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayThuLy.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                obj.NGAYTHULYXXGDT = date_temp;
               
            }
            if (!String.IsNullOrEmpty(txtNgayVKSTraHS.Text.Trim()))
            {
                date_temp = (String.IsNullOrEmpty(txtNgayVKSTraHS.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayVKSTraHS.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                obj.XXGDTTT_NGAYVKSTRAHS = date_temp;
            }

            obj.GQD_LOAIKETQUA = 1;//khang nghi
            obj.GQD_KETQUA = "Kháng nghị";
            obj.TRANGTHAIID = 14;
            if (!IsUpdate)
            {
                //Thông tin trạng thái thụ lý
                //obj.TRANGTHAIID = ENUM_GDTTT_TRANGTHAI.THULY_MOI;
                obj.NGAYTAO = DateTime.Now;
                obj.NGUOITAO = UserName;
                
                obj.ISTOTRINH = 0;
                dt.GDTTT_VUAN.Add(obj);
            }
            else
            {
                obj.NGAYSUA = DateTime.Now;
                obj.NGUOISUA = UserName;
            }
            //-----------------------
            dt.SaveChanges();
            hddVuAnID.Value = obj.ID.ToString();
            //Nếu có ngày nhận hồ sơ thì tạo phiếu nhận hồ sơ
            if (!String.IsNullOrEmpty(txtNgayGDNhanHS.Text.Trim()))
            {
                //-- tạo them phieu nhan hồ sơ
                //-----------------------
                try
                {
                    Decimal HosoID = UpdateHoSo(obj);
                    if (HosoID > 0)
                    {
                        obj.HOSOID = HosoID;
                        obj.ISHOSO = 1;
                    }
                    else
                        obj.HOSOID = obj.ISHOSO = 0;

                    dt.SaveChanges();
                }
                catch (Exception ex) { }
                //--------------------
            }
            Disenable_thongtinVA();
            return obj;
        }

        void Disenable_thongtinVA()
        {
            ddlLoaiBA.Enabled = false;

            if (pnPhucTham.Visible & !String.IsNullOrEmpty(txtNgayBA.Text.Trim()))
            {
                txtSoBA.Enabled = txtNgayBA.Enabled = false;
                dropToaAn.Enabled = false;
            }


            if (pnAnST.Visible & !String.IsNullOrEmpty(txtNgayBA_ST.Text.Trim()))
            {
                txtSoBA_ST.Enabled = txtNgayBA_ST.Enabled = dropToaAnST.Enabled = false;
            }
            if (!String.IsNullOrEmpty(txtNgayphancong.Text.Trim()))
            {
                txtNgayphancong.Enabled = false;
            }

            if (Convert.ToDecimal(dropTTV.SelectedValue) > 0)
            {
                dropTTV.Enabled = false;
            }

            if (!String.IsNullOrEmpty(txtNgayNhanTieuHS.Text.Trim()))
            {
                txtNgayNhanTieuHS.Enabled = false;
            }
            if (Convert.ToDecimal(dropLanhDao.SelectedValue) > 0)
                dropLanhDao.Enabled = false;
            if (!String.IsNullOrEmpty(txtNgayGDNhanHS.Text.Trim()))
                txtNgayGDNhanHS.Enabled = false;
        }
        void enable_thongtinVA() 
        {
            ddlLoaiBA.Enabled = true;
            txtSoBA.Enabled = txtNgayBA.Enabled =  dropToaAn.Enabled = true;
            txtSoBA_ST.Enabled = txtNgayBA_ST.Enabled = dropToaAnST.Enabled = true;
            txtNgayphancong.Enabled =  dropTTV.Enabled =  txtNgayNhanTieuHS.Enabled = dropLanhDao.Enabled =  txtNgayGDNhanHS.Enabled = true;
        }
        Decimal UpdateHoSo(GDTTT_VUAN objVA)
        {
            DateTime date_temp;
            Decimal CurrHoSoID = 0;
            Decimal VuAn_HoSoID = String.IsNullOrEmpty(objVA.HOSOID + "") ? 0 : (decimal)objVA.HOSOID;
            GDTTT_QUANLYHS objHS = new GDTTT_QUANLYHS();
            decimal thamtravien_id = (decimal)objVA.THAMTRAVIENID;
            if (thamtravien_id > 0)
            {
                decimal vuan_id = (decimal)objVA.ID;
                string NhanHS = "3";
                Boolean IsUpdate = false;
                List<GDTTT_QUANLYHS> lstHS = null;
                try
                {
                    if (!String.IsNullOrEmpty(txtNgayGDNhanHS.Text.Trim()))
                    {
                        date_temp = DateTime.Parse(this.txtNgayGDNhanHS.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

                        if (VuAn_HoSoID > 0)
                        {
                            try
                            {
                                objHS = dt.GDTTT_QUANLYHS.Where(x => x.ID == VuAn_HoSoID).Single();
                                CurrHoSoID = objHS.ID;
                                IsUpdate = true;
                            }
                            catch (Exception ex2)
                            {
                                IsUpdate = false;
                            }
                        }
                        else
                        {
                            lstHS = dt.GDTTT_QUANLYHS.Where(x => x.VUANID == vuan_id
                                                                && x.CANBOID == thamtravien_id
                                                                && x.LOAI == NhanHS
                                                           ).OrderByDescending(x => x.NGAYTAO).ToList();
                            if (lstHS != null && lstHS.Count > 0)
                            {
                                foreach (GDTTT_QUANLYHS objTemp in lstHS)
                                {
                                    DateTime ngay_tao_hs = (DateTime)objTemp.NGAYTAO;
                                    if (ngay_tao_hs == date_temp)
                                    {
                                        IsUpdate = true;
                                        objHS = objTemp;
                                        break;
                                    }
                                }
                            }
                        }
                    }
                }
                catch (Exception ex) { }
                if (!IsUpdate)
                {

                    DateTime ngaytao = System.DateTime.Now;
                    if (objHS.NGAYTAO == null)
                        ngaytao = System.DateTime.Now;
                    else
                        ngaytao = (DateTime)objHS.NGAYTAO;
                    // them mới
                    objHS = new GDTTT_QUANLYHS();
                    objHS.TRANGTHAI = 0;
                    objHS.VUANID = vuan_id;
                    objHS.SOPHIEU = GetNewSoPhieuNhanHS(3, ngaytao, CurrDonViID, PhongBanID);
                    objHS.GROUPID = Guid.NewGuid().ToString();
                    objHS.TENCANBO = dropTTV.SelectedItem.Text;
                    objHS.CANBOID = Convert.ToDecimal(dropTTV.SelectedValue);
                }
                if (!String.IsNullOrEmpty(txtNgayGDNhanHS.Text.Trim()))
                    objHS.NGAYTAO = DateTime.Parse(this.txtNgayGDNhanHS.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                else objHS.NGAYTAO = null;
                objHS.LOAI = NhanHS.ToString();
                //manhnd kiem tra nêu nhạp ngày Nhận hs thì mới tạo phieu nhận
                //if (!IsUpdate)
                if (!IsUpdate && !String.IsNullOrEmpty(txtNgayGDNhanHS.Text.Trim()))
                    dt.GDTTT_QUANLYHS.Add(objHS);
                dt.SaveChanges();
                CurrHoSoID = objHS.ID;
            }
            return CurrHoSoID;
        }
        //lấy số phiếu nhận tự động
        Decimal GetNewSoPhieuNhanHS(decimal loaiphieu, DateTime NgayTao, decimal DonviID, decimal PhongbanID)
        {
            GDTTT_VUAN_BL objBL = new GDTTT_VUAN_BL();
            Decimal SoCV = objBL.GetLastSoPhieuHS(loaiphieu, NgayTao, DonviID, PhongbanID);
            return SoCV;
        }
        protected void cmdSaveDSHinhSu_Click(object sender, EventArgs e)
        {
            GDTTT_VUAN obj = new GDTTT_VUAN();
            bool IsUpdate = false;
            Decimal UserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            String UserName = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERNAME] + "")) ? "" : (Session[ENUM_SESSION.SESSION_USERNAME] + "");
            Decimal CurrVuAnID = (String.IsNullOrEmpty(hddVuAnID.Value)) ? 0 : Convert.ToDecimal(hddVuAnID.Value + "");
            Decimal CurrBicaoID = (String.IsNullOrEmpty(hddBiCaoID.Value)) ? 0 : Convert.ToDecimal(hddBiCaoID.Value + "");
            if (CurrVuAnID == 0)
            {
                // UpdateThongTinVuAn();
                CurrVuAnID = (String.IsNullOrEmpty(hddVuAnID.Value)) ? 0 : Convert.ToDecimal(hddVuAnID.Value + "");
            }
            else if (CurrVuAnID > 0)
            {
                try
                {
                    obj = dt.GDTTT_VUAN.Where(x => x.ID == CurrVuAnID).Single<GDTTT_VUAN>();
                    if (obj != null)
                        IsUpdate = true;
                    else
                        obj = new GDTTT_VUAN();
                }
                catch (Exception ex) { obj = new GDTTT_VUAN(); }
            }
            else
                obj = new GDTTT_VUAN();


            if (IsUpdate)
            {
              UpdateDS(CurrBicaoID);
              LoadDanhSachBiCao();
              LoadDsToiDanh(CurrBicaoID);
              ClearFormBiCao();
            }
            else
                lttMsgTLXX.Text = "Vụ án không tồn tại. Bạn hãy kiểm tra lại!";
        }

        Decimal UpdateDS(decimal DuongSuID)
        {
            Decimal CurrVuAnID = (String.IsNullOrEmpty(hddVuAnID.Value)) ? 0 : Convert.ToDecimal(hddVuAnID.Value + "");
            GDTTT_VUAN_DUONGSU obj = null;
            Boolean IsUpdate = false;
            int  is_dauvu = 0, is_bicao = 0;
            is_bicao = chkBiCao.Checked ? 1 : 0;
            is_dauvu = chkBCDauVu.Checked ? 1 : 0;
            if (is_dauvu == 1)
                is_bicao = 1;
            if (DuongSuID > 0)
            {
                try
                {
                    obj = dt.GDTTT_VUAN_DUONGSU.Where(x => x.ID == DuongSuID && x.VUANID == CurrVuAnID).Single<GDTTT_VUAN_DUONGSU>();
                    if (obj != null)
                    {
                        IsUpdate = true;
                       
                    }
                    else obj = new GDTTT_VUAN_DUONGSU();
                }
                catch (Exception ex)
                {
                    obj = new GDTTT_VUAN_DUONGSU();
                }
            }
            else
                obj = new GDTTT_VUAN_DUONGSU();

            obj.VUANID = CurrVuAnID;

            obj.LOAI = 0;
            obj.GIOITINH = 2;

            obj.BICAOID = 0;
            obj.HS_TUCACHTOTUNG = "";
            //----------------------
            obj.HS_ISKHIEUNAI = 0;
            obj.HS_BICANDAUVU = is_dauvu;
            obj.HS_ISBICAO = is_bicao;

            if (is_bicao == 1 || is_dauvu == 1)
            {
                obj.TUCACHTOTUNG = ENUM_DANSU_TUCACHTOTUNG.BIDON;
                if (!String.IsNullOrEmpty(txtBC_HoTen.Text.Trim()))
                    obj.TENDUONGSU = Cls_Comon.FormatTenRieng(txtBC_HoTen.Text.Trim());
                if (Convert.ToDecimal(ddlNamsinh.SelectedValue)>0)
                    obj.NAMSINH = Convert.ToDecimal(ddlNamsinh.SelectedValue);
                obj.HS_MUCAN = txtBC_MucAn.Text.Trim();
            }
            //----------------------
            if (!IsUpdate)
            {
                obj.NGAYTAO = DateTime.Now;
                obj.NGUOITAO = UserName;
                dt.GDTTT_VUAN_DUONGSU.Add(obj);
                dt.SaveChanges();
                
            }
            else
            {
                obj.NGAYSUA = DateTime.Now;
                obj.NGUOISUA = UserName;
                dt.SaveChanges();
            }
            if (is_bicao == 1 || is_dauvu == 1)
            {
                //nếu tạo đương sự mới thì tạo tội danh
                UpdateToiDanhChoDS(obj.ID);
                //update tên vụ an 
                Update_TenVuAn(null);
            }
                
            //----------
            return obj.ID;
        }
        protected void cmdRefresh_Click(object sender, EventArgs e)
        {

            LoadDanhSachBiCao();
            pnBiCaoToiDanh.Visible = false;
            rptToiDanh.Visible = false;
            ClearFormBiCao();
        }
        //-------------------------------
        void Update_TenVuAn(GDTTT_VUAN oVA)
        {
            Decimal CurrVuAnID = (String.IsNullOrEmpty(hddVuAnID.Value)) ? 0 : Convert.ToDecimal(hddVuAnID.Value + "");

            string bican_dauvu = "", bican_khieunai = "", toidanh = "", toidanhDV ="";
            int is_bicao = 0, is_dauvu = 0;

            List<GDTTT_VUAN_DUONGSU> lst = dt.GDTTT_VUAN_DUONGSU.Where(x => x.VUANID == CurrVuAnID).OrderBy(y => y.TUCACHTOTUNG).ToList();
            if (lst != null && lst.Count > 0)
            {
                foreach (GDTTT_VUAN_DUONGSU ds in lst)
                {
                    is_bicao = String.IsNullOrEmpty(ds.HS_ISBICAO + "") ? 0 : Convert.ToInt16(ds.HS_ISBICAO + "");
                    is_dauvu = String.IsNullOrEmpty(ds.HS_BICANDAUVU + "") ? 0 : Convert.ToInt16(ds.HS_BICANDAUVU + "");
                   

                    if (is_dauvu == 1)
                    {
                        if (bican_dauvu != "")
                            bican_dauvu += (String.IsNullOrEmpty(bican_dauvu)) ? "" : ", ";
                        bican_dauvu += ds.TENDUONGSU;
                        toidanhDV += ((string.IsNullOrEmpty(toidanh + "")) ? "" : ", ") + ds.HS_TENTOIDANH;
                    }

                    if (is_bicao == 1)
                    {

                        if (ds.TENDUONGSU != "")
                        {
                            List<GDTTT_VUAN_DS_KN> obj = dt.GDTTT_VUAN_DS_KN.Where(x => x.BICAOID == ds.ID).ToList();
                            if (obj.Count > 0)
                            {
                                if (bican_khieunai != "")
                                    bican_khieunai += (String.IsNullOrEmpty(bican_khieunai)) ? "" : ", ";
                                bican_khieunai += ds.TENDUONGSU;
                            }

                        }


                        toidanh += ((string.IsNullOrEmpty(toidanh + "")) ? "" : ", ") + ds.HS_TENTOIDANH;
                    }

                   
                }
            }
            //---------------------------
            if (oVA == null)
                oVA = dt.GDTTT_VUAN.Where(x => x.ID == CurrVuAnID).Single();

            oVA.NGUYENDON = bican_dauvu;
            oVA.BIDON = bican_khieunai;
      
            //------------------
            if (!String.IsNullOrEmpty(bican_dauvu))
            {
                oVA.TENVUAN = bican_dauvu
                    + (String.IsNullOrEmpty(bican_dauvu + "") ? "" : (string.IsNullOrEmpty(toidanh + "") ? "" : " - "))
                    + toidanhDV;
            }
            else if (!String.IsNullOrEmpty(bican_khieunai))
            {
                oVA.TENVUAN = bican_khieunai
                    + (String.IsNullOrEmpty(bican_khieunai + "") ? "" : (string.IsNullOrEmpty(toidanh + "") ? "" : " - "))
                    + toidanh;
            }

            dt.SaveChanges();
        }


        protected void cmdLamMoi_Click(object sender, EventArgs e)
        {
            ClearForm(true);
        }
        void ClearForm(Boolean IsRefresh)
        {
            //--Thụ lý GDT
            txtSoThuLy.Text = "";
            txtNgayThuLy.Text = "";
            //--------------------------------
            txtSoBA.Text = txtNgayBA.Text = "";
            dropToaAn.SelectedIndex = 0;
        

            //--------------------------------
            dropTTV.SelectedIndex = 0;
            if (dropTTV.SelectedValue != "0")
            {
                decimal thamtravien = Convert.ToDecimal(dropTTV.SelectedValue);
                GetAllLanhDaoNhanBCTheoTTV(thamtravien);
            }
            else
                LoadDropLanhDao();
            dropThamPhan.SelectedIndex = 0;
            txtNgayNhanTieuHS.Text = "";
            txtNgayGDNhanHS.Text = "";
            txtGhiChu.Text = "";

            //--------------------------------
            if (IsRefresh == true && Request["ID"] != null)
                LoadInfo();
            else
            {
                hddVuAnID.Value = "0";
            }
        }

        //---------------------------
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
            //GDTTT_VUAN obj = Update_VuAn();

            ////Update duong su
            //Update_DuongSu_AnHS(obj);

            //LoadDropBiCao(false);
            //dropBiCao.SelectedValue = hddBiCaoDuocKN.Value;
            //Decimal DuongSuID = 0;
            //if (dropBiCao_ToiDanh.SelectedValue != "0")
            //{

            //    if (dropBiCao.SelectedValue == "-1")
            //        DuongSuID = Convert.ToDecimal(hddBiCaoDuocKN.Value);
            //    else
            //        DuongSuID = Convert.ToDecimal(hddBiCaoID.Value);
            //    UpdateToiDanhChoDS(DuongSuID);
            //}
            //Update_TenVuAn(obj);
            //LoadDanhSachBiCao();
            //LoadDropBiCao(false);
            ////dropBiCao_SelectedIndexChanged(null, null);

            //Cls_Comon.SetValueComboBox(dropBiCao, DuongSuID);

            lttMsgBC.Text = "Thêm tội danh cho bị cáo thành công!";
        }
        //-----------------
        protected void rptToiDanh_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            decimal curr_id = 0;
            switch (e.CommandName)
            {
                case "Xoa":
                    curr_id = Convert.ToDecimal(e.CommandArgument.ToString());
                    XoaToiDanh(curr_id);
                    Update_TenVuAn(null);
                    break;
            }
        }
        void XoaToiDanh(Decimal currID)
        {
            Decimal DuongSuID = 0;
            GDTTT_VUAN_DUONGSU_TOIDANH item = dt.GDTTT_VUAN_DUONGSU_TOIDANH.Where(x => x.ID == currID).Single();
            if (item != null)
            {
                DuongSuID = (Decimal)item.DUONGSUID;
                dt.GDTTT_VUAN_DUONGSU_TOIDANH.Remove(item);
                dt.SaveChanges();

                UpdateListToiDanh_BiCao(DuongSuID);
                LoadDsToiDanh(DuongSuID);
                LoadDanhSachBiCao();
                lttMsgBC.Text = "Xóa tội danh thành công";
            }
        }
        void UpdateToiDanhChoDS(Decimal DuongSuID)
        {
            Decimal CurrVuAnID = (String.IsNullOrEmpty(hddVuAnID.Value)) ? 0 : Convert.ToDecimal(hddVuAnID.Value + "");
            decimal currtoidanhId = Convert.ToDecimal(dropBiCao_ToiDanh.SelectedValue);
            List<GDTTT_VUAN_DUONGSU_TOIDANH> lst = dt.GDTTT_VUAN_DUONGSU_TOIDANH.Where(x => x.VUANID == CurrVuAnID
                                                                                            && x.DUONGSUID == DuongSuID
                                                                                            && x.TOIDANHID == currtoidanhId).ToList();
            if (lst == null || lst.Count == 0)
            {
                GDTTT_VUAN_DUONGSU_TOIDANH obj = new GDTTT_VUAN_DUONGSU_TOIDANH();
                obj.DUONGSUID = DuongSuID;
                obj.VUANID = CurrVuAnID;
                obj.TOIDANHID = currtoidanhId;
                obj.TENTOIDANH = dropBiCao_ToiDanh.SelectedItem.Text.Trim();
                dt.GDTTT_VUAN_DUONGSU_TOIDANH.Add(obj);
                dt.SaveChanges();
                lttMsg.Text = "Thêm tội danh thành công";
                //----------------
                UpdateListToiDanh_BiCao(DuongSuID);
                //-------------------
                dropBiCao_ToiDanh.SelectedIndex = 0;
                LoadDsToiDanh(DuongSuID);
            }
        }
        void UpdateListToiDanh_BiCao(Decimal DuongSuID)
        {
            String StrToiDanh = "";
            Decimal CurrVuAnID = (String.IsNullOrEmpty(hddVuAnID.Value)) ? 0 : Convert.ToDecimal(hddVuAnID.Value + "");
            GDTTT_VUAN_DUONGSU oBC = dt.GDTTT_VUAN_DUONGSU.Where(x => x.ID == DuongSuID).Single();
            List<GDTTT_VUAN_DUONGSU_TOIDANH> lst = dt.GDTTT_VUAN_DUONGSU_TOIDANH.Where(x => x.VUANID == CurrVuAnID
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
        //-------------------------------------------

        public void LoadDanhSachBiCao()
        {
            Decimal CurrVuAnID = (String.IsNullOrEmpty(hddVuAnID.Value)) ? 0 : Convert.ToDecimal(hddVuAnID.Value + "");
            GDTTT_VUANVUVIEC_DUONGSU_BL objBL = new GDTTT_VUANVUVIEC_DUONGSU_BL();
            DataTable tbl = objBL.AnHS_GetAllDuongSu(CurrVuAnID, "", 2);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                int count_all = Convert.ToInt32(tbl.Rows.Count);
                rptBiCao.DataSource = tbl;
                rptBiCao.DataBind();
                rptBiCao.Visible = true;
            }
            else rptBiCao.Visible = false;
        }
        void LoadDsToiDanh(Decimal DuongSuID)
        {
            Decimal CurrVuAnID = (String.IsNullOrEmpty(hddVuAnID.Value)) ? 0 : Convert.ToDecimal(hddVuAnID.Value + "");
            List<GDTTT_VUAN_DUONGSU_TOIDANH> lst = dt.GDTTT_VUAN_DUONGSU_TOIDANH.Where(x => x.VUANID == CurrVuAnID
                                                                                         && x.DUONGSUID == DuongSuID
                                                                                      ).ToList();
            if (lst != null && lst.Count > 0)
            {
                rptToiDanh.DataSource = lst;
                rptToiDanh.DataBind();
                rptToiDanh.Visible = true;
            }
            else
            {
                rptToiDanh.DataSource = null;
                rptToiDanh.DataBind();
                rptToiDanh.Visible = false;
            }
        }
        //----------------------------
       
        protected void rptBiCao_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                String temp = "";
                DataRowView dv = (DataRowView)e.Item.DataItem;
                //Repeater rptBCKN = (Repeater)e.Item.FindControl("rptBCKN");
                Literal lttBiCao = (Literal)e.Item.FindControl("lttBiCao");
                Literal lttTenDS = (Literal)e.Item.FindControl("lttTenDS");
                Control td_sua_div = e.Item.FindControl("td_sua_div");
                int is_bicao = Convert.ToInt16(dv["HS_IsBiCao"] + "");
                int is_dauvu = Convert.ToInt16(dv["HS_BiCanDauVu"] + "");
                
                lttTenDS.Text = dv["TenDuongSu"] + "";
                if (is_dauvu == 1)
                    lttTenDS.Text += "<span class='loaibc'>(BC đầu vụ)</span>";
                else if (is_bicao == 1)
                    lttTenDS.Text += "<span class='loaibc'>(Bị cáo)</span>";

                String tentoidanh = String.IsNullOrEmpty(dv["HS_TenToiDanh"] + "") ? "" : "Tội danh:" + dv["HS_TenToiDanh"] + "";
                String muc_an = String.IsNullOrEmpty(dv["HS_MucAn"] + "") ? "" : "Mức án: " + dv["HS_MucAn"] + "";
                temp = muc_an + (String.IsNullOrEmpty(muc_an + "") ? "" : (string.IsNullOrEmpty(tentoidanh) ? "" : "</br>")) + tentoidanh;

                //td_sua_div.Visible = true;
                //lttBiCao.Text = temp;

                //lttBiCao.Visible = true;


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

                        XoaDuongSu_AnHS(curr_id);
                        ClearFormBiCao();
                        Update_TenVuAn(null);
                        LoadDanhSachBiCao();
                        lttMsgBC.Text = "Xóa bị cáo thành công";

                        

                    }
                    break;
            }
        }
        void XoaDuongSu_AnHS(decimal curr_duongsu_id)
        {
            Decimal CurrVuAnID = (String.IsNullOrEmpty(hddVuAnID.Value)) ? 0 : Convert.ToDecimal(hddVuAnID.Value + "");
            if (curr_duongsu_id > 0)
            {
                GDTTT_VUAN_DUONGSU oT = dt.GDTTT_VUAN_DUONGSU.Where(x => x.ID == curr_duongsu_id).FirstOrDefault();
                if (oT != null)
                {
                    XoaAllToiDanh(curr_duongsu_id);
                    //------------------------------------
                    dt.GDTTT_VUAN_DUONGSU.Remove(oT);
                    dt.SaveChanges();
                }
                //------------------------------------
                Update_TenVuAn(null);
            }
            lttMsg.Text = lttMsgT.Text = "Xóa thành công!";
        }
        void XoaAllToiDanh(Decimal DuongsuID)
        {
            Decimal CurrVuAnID = (String.IsNullOrEmpty(hddVuAnID.Value)) ? 0 : Convert.ToDecimal(hddVuAnID.Value + "");

            List<GDTTT_VUAN_DUONGSU_TOIDANH> lst = dt.GDTTT_VUAN_DUONGSU_TOIDANH.Where(x => x.VUANID == CurrVuAnID
                                                                                         && x.DUONGSUID == DuongsuID).ToList();
            if (lst != null && lst.Count > 0)
            {
                foreach (GDTTT_VUAN_DUONGSU_TOIDANH item in lst)
                    dt.GDTTT_VUAN_DUONGSU_TOIDANH.Remove(item);
            }
            dt.SaveChanges();
        }
        public void LoadInfoBiCao()
        {
            //try { ClearFormBiCao(); } catch (Exception ex) { }
            decimal CurrDuongSuID = Convert.ToDecimal(hddBiCaoID.Value);
            try
            {
                LoadThongTinBC_AHS(CurrDuongSuID);
            }
            catch (Exception ex) { }
        }

        void LoadThongTinBC_AHS(Decimal DuongSuID)
        {
            int is_dauvu = 0, is_bicao = 0;
            GDTTT_VUAN_DUONGSU obj = dt.GDTTT_VUAN_DUONGSU.Where(x => x.ID == DuongSuID).Single();

            if (obj != null)
            {
               
                is_bicao = String.IsNullOrEmpty(obj.HS_ISBICAO + "") ? 0 : Convert.ToInt16(obj.HS_ISBICAO + "");
                is_dauvu = String.IsNullOrEmpty(obj.HS_BICANDAUVU + "") ? 0 : Convert.ToInt16(obj.HS_BICANDAUVU + "");
               
                chkBCDauVu.Checked = is_dauvu == 1 ? true : false;
                chkBiCao.Checked = is_bicao == 1 ? true : false;
               
                txtBC_MucAn.Text = obj.HS_MUCAN;
                if (obj.NAMSINH > 0)
                    ddlNamsinh.SelectedValue = Convert.ToString(obj.NAMSINH);
                else
                    ddlNamsinh.SelectedValue = "0";

                #region Bi cao dau vu/ bi cao

                txtBC_HoTen.Visible = true;
                txtBC_HoTen.Text = obj.TENDUONGSU;
                pnBiCaoToiDanh.Visible = true;
                rptToiDanh.Visible = true;
                LoadDsToiDanh(DuongSuID);
                    #endregion
               
            }
        }
        void ClearFormBiCao()
        {
            try
            {
                lttMsg.Text = lttMsgBC.Text = lttMsgT.Text = "";
               
                chkBCDauVu.Visible = chkBiCao.Visible = true;
                chkBCDauVu.Checked = chkBiCao.Checked = false;

               

                txtBC_HoTen.Text = txtBC_MucAn.Text = "";
                dropBiCao_ToiDanh.SelectedIndex = 0;
                ddlNamsinh.SelectedValue = "0";
                rptToiDanh.DataSource = null;
                rptToiDanh.DataBind();
                rptToiDanh.Visible = false;
                hddBiCaoID.Value = "";
                lttMsgBC.Text = "";
                LoadDanhSachBiCao();
            }
            catch (Exception ex) { }
        }
        //------------------------------
        protected void ddlLoaiBA_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (ddlLoaiBA.SelectedValue == "1")
            {
                pnPhucTham.Visible = true;
                pnAnST.Visible = true;
            }
            else if (ddlLoaiBA.SelectedValue == "0")
            {
                pnPhucTham.Visible = false;
                pnAnST.Visible = true;
                LoadDropToaPT_ST();
            }
            else
            {
                pnPhucTham.Visible = false;
                pnAnST.Visible = true;
                LoadDropToaPT_Full();
            }
        }
        void LoadDropToaPT_Full()
        {
            dropToaAnST.Items.Clear();
            DM_TOAAN_BL oTABL = new DM_TOAAN_BL();
            DataTable dtTA = oTABL.DM_TOAAN_GETBYNOTCUR(0, 0);
            dropToaAnST.DataSource = dtTA;
            dropToaAnST.DataTextField = "MA_TEN";
            dropToaAnST.DataValueField = "ID";
            dropToaAnST.DataBind();
            dropToaAnST.Items.Insert(0, new ListItem("Chọn", "0"));
        }
        //anhvh 14/11/2019
        void LoadDropToaPT_ST()
        {
            dropToaAnST.Items.Clear();
            DM_TOAAN_BL oTABL = new DM_TOAAN_BL();
            DataTable dtTA = oTABL.DM_TOAAN_GETBYNOTCUR_ST();
            dropToaAnST.DataSource = dtTA;
            dropToaAnST.DataTextField = "MA_TEN";
            dropToaAnST.DataValueField = "ID";
            dropToaAnST.DataBind();
            dropToaAnST.Items.Insert(0, new ListItem("Chọn", "0"));
        }




        //--------------------------------------------------

        protected void cmdUpdateVKS_Click(object sender, EventArgs e)
        {
            GDTTT_VUAN obj = new GDTTT_VUAN();

            bool IsUpdate = false;
            Decimal UserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            String UserName = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERNAME] + "")) ? "" : (Session[ENUM_SESSION.SESSION_USERNAME] + "");
            Decimal CurrVuAnID = (String.IsNullOrEmpty(hddVuAnID.Value)) ? 0 : Convert.ToDecimal(hddVuAnID.Value + "");
            if (CurrVuAnID == 0)
            {
                obj = UpdateThongTinVuAn();
                CurrVuAnID = (String.IsNullOrEmpty(hddVuAnID.Value)) ? 0 : Convert.ToDecimal(hddVuAnID.Value + "");
            }
            else if (CurrVuAnID > 0)
            {
                try
                {
                    obj = dt.GDTTT_VUAN.Where(x => x.ID == CurrVuAnID).Single<GDTTT_VUAN>();
                    if (obj != null)
                        IsUpdate = true;
                    else
                        obj = new GDTTT_VUAN();
                }
                catch (Exception ex) { obj = new GDTTT_VUAN(); }
            }

            if (IsUpdate)
            {
                obj.VIENTRUONGKN_SO = obj.GDQ_SO = txtVKS_So.Text;
                DateTime date_temp = (String.IsNullOrEmpty(txtVKS_Ngay.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtVKS_Ngay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                obj.VIENTRUONGKN_NGAY = obj.GDQ_NGAY = date_temp;
                obj.VIENTRUONGKN_NGUOIKY = Convert.ToDecimal(dropVKS_NguoiKy.SelectedValue);
                obj.GQD_LOAIKETQUA = 1;//khang nghi
                obj.GQD_KETQUA = "Kháng nghị";
                obj.TRANGTHAIID = 14;
                //---------------------------------
                obj.ISVIENTRUONGKN = 1;
                //-Thong tin KN của VKS---------

                dt.SaveChanges();

                lttMsgHSKN_VKS.ForeColor = System.Drawing.Color.Blue;
                lttMsgHSKN_VKS.Text = "Cập nhật dữ liệu thành công!";
            }
            //LoadDSHoiDongTP_DaChon();
        }
        protected void cmdXoa_VKS_Click(object sender, EventArgs e)
        {
            Decimal CurrVuAnID = (String.IsNullOrEmpty(hddVuAnID.Value)) ? 0 : Convert.ToDecimal(hddVuAnID.Value + "");
            GDTTT_VUAN obj = dt.GDTTT_VUAN.Where(x => x.ID == CurrVuAnID).Single<GDTTT_VUAN>();
            if (obj != null)
            {
                obj.VIENTRUONGKN_SO = "";
                obj.VIENTRUONGKN_NGAY = null;
                obj.VIENTRUONGKN_NGUOIKY = 0;
                dt.SaveChanges();
                //---------------------
                txtVKS_So.Text = txtVKS_Ngay.Text = "";
                dropVKS_NguoiKy.SelectedValue = "0";
                //---------------------
                lttMsg.ForeColor = System.Drawing.Color.Blue;
                lttMsg.Text = "Xóa dữ liệu thành công!";
            }
            // LoadDSHoiDongTP_DaChon();
        }
        protected void txtVKS_Ngay_TextChanged(object sender, EventArgs e)
        {
            Decimal PhongBanID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_PHONGBANID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);
            DateTime Ngay = (DateTime)((String.IsNullOrEmpty(txtVKS_Ngay.Text.Trim())) ? (DateTime?)DateTime.Now : DateTime.Parse(this.txtVKS_Ngay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault));

            GDTTT_VUAN_BL objBL = new GDTTT_VUAN_BL();
            /*Loai =1: VIENTRUONGKN , 2: THU LY XXGDTTT, 3: KET QUA XXGDTTT*/
            Decimal SoCV = objBL.XXGDTTT_GetLastSoQD(PhongBanID, Ngay, 1);
            txtVKS_So.Text = SoCV + "";
            //LoadDSHoiDongTP_DaChon();
        }
        protected void txtNgayThuLy_TextChanged(object sender, EventArgs e)
        {
            Decimal PhongBanID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_PHONGBANID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);
            DateTime NgayThuLyGDT = (DateTime)((String.IsNullOrEmpty(txtNgayThuLy.Text.Trim())) ? (DateTime?)DateTime.Now : DateTime.Parse(this.txtNgayThuLy.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault));

            GDTTT_VUAN_BL objBL = new GDTTT_VUAN_BL();
            /*Loai =1: VIENTRUONGKN , 2: THU LY XXGDTTT, 3: KET QUA XXGDTTT*/
            Decimal SoCV = objBL.XXGDTTT_GetLastSoQD(PhongBanID, NgayThuLyGDT, 2);
            txtSoThuLy.Text = SoCV + "";
            //LoadDSHoiDongTP_DaChon();
        }
        //------------------------------
        protected void cmdUpdateTTXX_Click(object sender, EventArgs e)
        {
            GDTTT_VUAN obj = new GDTTT_VUAN();
            bool IsUpdate = false;
            Decimal UserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            String UserName = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERNAME] + "")) ? "" : (Session[ENUM_SESSION.SESSION_USERNAME] + "");
            Decimal CurrVuAnID = (String.IsNullOrEmpty(hddVuAnID.Value)) ? 0 : Convert.ToDecimal(hddVuAnID.Value + "");
            if (CurrVuAnID == 0)
            {
               obj = UpdateThongTinVuAn();
                CurrVuAnID = (String.IsNullOrEmpty(hddVuAnID.Value)) ? 0 : Convert.ToDecimal(hddVuAnID.Value + "");
            }
            else if (CurrVuAnID > 0)
            {
                try
                {
                    obj = dt.GDTTT_VUAN.Where(x => x.ID == CurrVuAnID).Single<GDTTT_VUAN>();
                    if (obj != null)
                        IsUpdate = true;
                    else
                        obj = new GDTTT_VUAN();
                }
                catch (Exception ex) { obj = new GDTTT_VUAN(); }
            }
            else
                obj = new GDTTT_VUAN();
            if (IsUpdate)
            {
                obj.SOTHULYXXGDT = txtSoThuLy.Text.Trim();
                DateTime date_temp = (String.IsNullOrEmpty(txtNgayThuLy.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayThuLy.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                obj.NGAYTHULYXXGDT = date_temp;

                //date_temp = (String.IsNullOrEmpty(txtNgayLichGDT.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayLichGDT.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                //obj.NGAYLICHGDT = date_temp;

                date_temp = (String.IsNullOrEmpty(txtNgayVKSTraHS.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayVKSTraHS.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                obj.XXGDTTT_NGAYVKSTRAHS = date_temp;

                obj.NGAYSUA = DateTime.Now;
                obj.NGUOISUA = UserName;
                obj.TRANGTHAIID = ENUM_GDTTT_TRANGTHAI.THULY_XETXU_GDT;

                //-----------------------
                dt.SaveChanges();
                lttMsgTLXX.ForeColor = System.Drawing.Color.Blue;
                lttMsgTLXX.Text = "Cập nhật dữ liệu thành công!";
            }
            else
                lttMsgTLXX.Text = "Vụ án không tồn tại. Bạn hãy kiểm tra lại!";
            //LoadDSHoiDongTP_DaChon();
        }
        protected void cmdXoa_TTXX_Click(object sender, EventArgs e)
        {
            //xoa Thông tin thụ lý xét xử GĐT,TT
            Decimal CurrVuAnID = (String.IsNullOrEmpty(hddVuAnID.Value)) ? 0 : Convert.ToDecimal(hddVuAnID.Value + "");
            GDTTT_VUAN obj = dt.GDTTT_VUAN.Where(x => x.ID == CurrVuAnID).Single<GDTTT_VUAN>();
            if (obj != null)
            {
                obj.SOTHULYXXGDT = "";
                obj.NGAYTHULYXXGDT = null;
                obj.NGAYLICHGDT = null;
                obj.XXGDTTT_NGAYVKSTRAHS = null;

                obj.NGAYSUA = DateTime.Now;
                obj.NGUOISUA = UserName;
                obj.TRANGTHAIID = ENUM_GDTTT_TRANGTHAI.THULY_XETXU_GDT;

                dt.SaveChanges();
                //---------------------
                txtSoThuLy.Text = txtNgayThuLy.Text = txtNgayVKSTraHS.Text = "";
                //---------------------
                lttMsg.ForeColor = System.Drawing.Color.Blue;
                lttMsg.Text = "Xóa dữ liệu thành công!";
            }
            // LoadDSHoiDongTP_DaChon();
        }
        //------------------------------

        protected void cmdQuaylai_Click(object sender, EventArgs e)
        {
            Response.Redirect("Danhsach.aspx");
        }
    }
}