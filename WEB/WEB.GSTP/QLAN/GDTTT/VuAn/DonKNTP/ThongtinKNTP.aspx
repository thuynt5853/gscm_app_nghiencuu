<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="ThongtinKNTP.aspx.cs" Inherits="WEB.GSTP.QLAN.GDTTT.VuAn.DonKNTP.ThongtinKNTP" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script src="../../../UI/js/Common.js"></script>
    <asp:HiddenField ID="hddID" runat="server" Value="0" />
    <asp:HiddenField ID="hddGUID" runat="server" Value="" />
    <asp:HiddenField ID="hddNext" runat="server" Value="0" />
    <asp:HiddenField ID="hddIsAnPT" runat="server" Value="PT" />
    <asp:HiddenField ID="HiddenField1" runat="server" Value="0" />

    
    <style>
        .clear_bottom {
            margin-bottom: 0px;
        }

        .button_empty {
            border: 1px solid red;
            border-radius: 4px;
            box-shadow: 0 3px 7px rgba(0, 0, 0, 0.2);
            color: #044271;
            background: white;
            float: left;
            font-size: 12px;
            font-weight: bold;
            line-height: 23px;
            padding: 0px 5px;
            margin-left: 3px;
            margin-bottom: 8px;
            text-decoration: none;
        }

        .tableva {
            /*border: solid 1px #dcdcdc;width: 100%;*/
            border-collapse: collapse;
            margin: 5px 0;
        }

            .tableva td {
                padding: 2px;
                padding-left: 2px;
                padding-left: 5px;
                vertical-align: middle;
            }
        /*-------------------------------------*/
        .table_list {
            border: solid 1px #dcdcdc;
            border-collapse: collapse;
            margin: 5px 0;
            width: 100%;
        }


            .table_list .header {
                background: #db212d;
                border: solid 1px #dcdcdc;
                padding: 2px;
                font-weight: bold;
                height: 30px;
                color: #ffffff;
            }

            .table_list header td {
                background: #db212d;
                border: solid 1px #dcdcdc;
                padding: 2px;
            }

            .table_list td {
                border: solid 1px #dcdcdc;
                padding: 5px;
                line-height: 17px;
            }
             .ajax__calendar_container {
            width: 220px;
        }

        .ajax__calendar_body {
            width: 100%;
            height: 140px;
        }
    </style>
    <div class="box">
        <div class="box_nd">
            <div class="truong">
                
                <div style="margin: 5px; width: 95%; color: red;">
                    <asp:Label ID="lttMsgT" runat="server"></asp:Label>
                </div>
                <div class="boxchung">
  
                    <div style="float: left; margin-top: 8px; width: 100%;">
                        <h4 class="tleboxchung">Thông tin BA/QĐ đề nghị GĐT,TT</h4>
                        <div class="boder" style="padding: 10px;">
                            <table class="tableva">
                                <tr>
                                    <td style="width: 120px;">Hình thức <span class="batbuoc">*</span></td>
                                    <td style="width: 255px;">
                                        <asp:DropDownList ID="dropLoaiGDT" CssClass="chosen-select"  OnSelectedIndexChanged="dropLoaiGDT_SelectedIndexChanged"
                                            AutoPostBack="true"  runat="server" Width="250px">
                                            <asp:ListItem Value="8" Text="Đơn Khiếu nại Tư pháp"></asp:ListItem>
                                            <asp:ListItem Value="10" Text="Đơn Khiếu nại Tư pháp kèm CV chuyển đơn"></asp:ListItem>
                                        </asp:DropDownList>
                                        <!--Dung trường TRUONGHOPTHULY de phan biet-->
                                    </td>   
                                    
                                    <td></td>
                                    <td>
                                       
                                    </td>
                                   
                                 </tr>
                               
                                 <tr>
                                    <td style="width: 120px;">Loại bản án</td>
                                    <td style="width: 255px;">
                                       <asp:DropDownList ID="ddlLoaiBA" CssClass="chosen-select"
                                            AutoPostBack="true" 
                                            runat="server" Width="250px">
                                            <asp:ListItem Value="3" Text="Phúc thẩm" Selected ="True"></asp:ListItem>
                                            <asp:ListItem Value="2" Text="Sơ thẩm"></asp:ListItem>
                                            <asp:ListItem Value="4" Text="QĐ GĐT"></asp:ListItem>
                                        </asp:DropDownList>

                                    </td>
                                    <td style="width: 95px;">Loại án <span class='batbuoc'>*</span></td>
                                    <td>
                                       <asp:DropDownList ID="dropLoaiAn" runat="server"
                                            Width="250px" CssClass="chosen-select"
                                            AutoPostBack="true" OnSelectedIndexChanged="dropLoaiAn_SelectedIndexChanged">
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                               
                                <tr>
                                    <td style="width: 120px;">Số BA/QĐ Phúc thẩm
                                        <%--<asp:Literal ID="lstTitleSOBA" runat="server" Text="Số BA/QĐ Phúc thẩm"></asp:Literal> <span class="batbuoc">*</span>--%>
                                        <asp:Literal ID="lttBB_SoPT" runat="server" Text="<span class='batbuoc'>*</span>"></asp:Literal>
                                    </td>
                                    <td style="width: 255px;">
                                        <asp:TextBox ID="txtSoBA" CssClass="user" runat="server" Width="242px"></asp:TextBox></td>
                                    <td style="width: 95px;">Ngày BA/QĐ Phúc thẩm
                                        <%--<asp:Literal ID="lstTitleNgayBA" runat="server" Text="Ngày BA/QĐ Phúc thẩm"></asp:Literal><span class="batbuoc">*</span>--%>
                                        <asp:Literal ID="lttBB_NgayPT" runat="server" Text="<span class='batbuoc'>*</span>"></asp:Literal>
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtNgayBA" CssClass="user" runat="server" Width="242px"></asp:TextBox>
                                        <cc1:CalendarExtender ID="CalendarExtender5" runat="server" TargetControlID="txtNgayBA" Format="dd/MM/yyyy" Enabled="true" />
                                        <cc1:MaskedEditExtender ID="MaskedEditExtender5" runat="server" TargetControlID="txtNgayBA"
                                            Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>Tòa án xét xử PT
                                       <%-- <asp:Literal ID="lstTitleToaXX" runat="server" Text="Tòa án xét xử PT"></asp:Literal><span class="batbuoc">*</span>--%>
                                        <asp:Literal ID="lttBB_ToaPT" runat="server" Text="<span class='batbuoc'>*</span>"></asp:Literal>
                                    </td>
                                    <td>
                                        <asp:DropDownList ID="dropToaAn" CssClass="chosen-select"
                                            AutoPostBack="true" OnSelectedIndexChanged="dropToaAn_SelectedIndexChanged"
                                            runat="server" Width="250px">
                                        </asp:DropDownList>
                                    </td>
                                    <td></td>
                                    <td>
                                        
                                    </td>
                                </tr>
                               
                                <!-------------------------------->
                                <tr>
                                    <td>Nội dung khiếu nại<span class="batbuoc">*</span></td>
                                    <td>
                                        <span  style="display:none">
                                             <asp:DropDownList ID="dropQHPL"
                                                CssClass="chosen-select" runat="server" Width="250">
                                            </asp:DropDownList>
                                         </span>
                                        <asp:TextBox ID="txtQHPL_TEXT" Width="96%" CssClass="user" TextMode="multiline" Rows="3"
                                                                placeholder="Quan hệ pháp luật(*)"
                                                                runat="server" Text='<%#Eval("QHPL_TEXT") %>'></asp:TextBox>

                                    </td>
                                    <td style="display: none;">Quan hệ PL tranh chấp<span class="batbuoc">*</span></td>
                                    <td style="display: none;">
                                        <asp:DropDownList ID="dropQHPLThongKe"
                                            CssClass="chosen-select" runat="server" Width="250px">
                                            <asp:ListItem Value="0" Text="Chọn"></asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                   <!---------------------------->
                    <asp:Panel ID="pnThuLyDon" runat="server"  Style="display: none;">
                    <div style="float: left; margin-top: 8px; width: 100%;">
                        <h4 class="tleboxchung">Thông tin thụ lý đơn đề nghị GĐT,TT</h4>
                        <div class="boder" style="padding: 10px;">
                             <table class="tableva">
                            <tr>
                                <td style="width: 120px;">Số thụ lý</td>
                                <td style="width: 255px;">
                                    <asp:TextBox ID="txtSoThuLy" CssClass="user" runat="server"
                                        Width="242px"></asp:TextBox>
                                </td>
                                <td style="width: 95px;">Ngày thụ lý</td>
                                <td>
                                    <asp:TextBox ID="txtNgayThuLy" CssClass="user" runat="server" Width="242px"></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender3" runat="server" TargetControlID="txtNgayThuLy" Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender4" runat="server" TargetControlID="txtNgayThuLy" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />

                                </td>
                            </tr>
                            <tr>
                                <td>Người đề nghị</td>
                                <td>
                                    <asp:TextBox ID="txtNguoiDeNghi" CssClass="user" runat="server" Width="242px"></asp:TextBox>
                                </td>
                                <td>Địa chỉ</td>
                                <td>
                                    <asp:TextBox ID="txtNguoiDeNghi_DiaChi" CssClass="user" runat="server" Width="242px"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td>Ngày ghi trên đơn/Ngày gửi đơn</td>
                                <td>
                                    <asp:TextBox ID="txtNgayTrongDon" CssClass="user" runat="server" Width="242px"></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtNgayTrongDon" Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtNgayTrongDon" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                </td>
                                <td>Ngày nhận đơn</td>
                                <td>
                                    <asp:TextBox ID="txtNgayNhanDon" CssClass="user" runat="server" Width="242px"></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtNgayNhanDon" Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtNgayNhanDon" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                </td>
                            </tr>
                        </table>
                        </div>
                    </div>
                    </asp:Panel>
                    <!---------------------------->
                    <div style="float: left; margin-top: 8px; width: 100%;">
                        <h4 class="tleboxchung">Thẩm tra viên/ Lãnh đạo  
                        </h4>
                        <div class="boder" style="padding: 10px;">
                                <table class="tableva">
                                    <tr><td colspan="4"><a href="javascript:;" style="font-weight:bold; color:#0E7EEE; text-decoration:none;"
                                        onclick="OpenLS();">Lịch sử phân công</a></td>
                                    <tr>
                                        <td style="width: 120px;">Ngày phân công</td>
                                        <td style="width: 255px;">
                                            <asp:TextBox ID="txtNgayphancong" CssClass="user" runat="server" Width="242px"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender7" runat="server" TargetControlID="txtNgayphancong" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender7" runat="server" TargetControlID="txtNgayphancong" Mask="99/99/9999"
                                                MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        </td>
                                        <td style="width: 95px;">Thẩm tra viên</td>
                                        <td>
                                            <asp:DropDownList ID="dropTTV"
                                                AutoPostBack=" true" OnSelectedIndexChanged="dropTTV_SelectedIndexChanged"
                                                CssClass="chosen-select" runat="server" Width="250">
                                            </asp:DropDownList>
                                            <span style="margin-left:10px;"><asp:CheckBox ID="chkModify_TTV" runat="server" Text="Thay đổi"/></span></td>
                                        
                                    </tr>
                                    <tr>
                                        <td>Ngày TTV nhận đơn đề nghị và các tài liệu kèm theo </td>
                                        <td>
                                            <asp:TextBox ID="txtNgayNhanTieuHS" CssClass="user" runat="server" Width="242px"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender4" runat="server" TargetControlID="txtNgayNhanTieuHS" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server" TargetControlID="txtNgayNhanTieuHS" Mask="99/99/9999"
                                                MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        </td>
                                        <td>Ngày TTV nhận hồ sơ </td>
                                        <td>
                                            <asp:TextBox ID="txtNgayNhanHS" CssClass="user" runat="server" Width="242px"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender8" runat="server" TargetControlID="txtNgayNhanHS" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender8" runat="server" TargetControlID="txtNgayNhanHS" Mask="99/99/9999"
                                                MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        </td>
                                    </tr>  <tr><td></td><td></td>
                                                    <td colspan="2"><i>(Lưu ý: hệ thống sẽ tự động tạo phiếu nhận tương ứng nếu mục 'Ngày TTV nhận hồ sơ' được chọn)</i></td>
                                                </tr>
                                    <tr>
                                        
                                        <td>Ngày Vụ GĐ nhận hồ sơ</td>
                                        <td>
                                            <asp:TextBox ID="txtNgayGDNhanHS" CssClass="user" runat="server" Width="242px"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender6" runat="server" TargetControlID="txtNgayGDNhanHS" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender6" runat="server" TargetControlID="txtNgayGDNhanHS" Mask="99/99/9999"
                                                MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        </td>
                                        <td>Phó Chánh án</td>
                                        <td>
                                            <asp:DropDownList ID="dropThamPhan"
                                                CssClass="chosen-select" runat="server" Width="250">
                                            </asp:DropDownList>
                                            <span style="margin-left:10px;"><asp:CheckBox ID="chkModify_TP" runat="server" Text="Thay đổi"/></span></td>
                                       
                                    </tr>
                                    <tr>

                                        <td>Ghi chú</td>
                                        <td colspan="3">
                                            <asp:TextBox ID="txtGhiChu" CssClass="user"
                                                runat="server" Width="605px"></asp:TextBox>
                                        </td>
                                    </tr>
                                </table>
                        
                        </div>
                    </div>
                   
                   <div style="float: left; margin-top: 8px; width: 100%;">
                        <div style="text-align: center;margin-top: 8px;  width: 100%">
                            <asp:Button ID="cmdUpdate2" runat="server" CssClass="buttoninput" Text="Lưu"
                                OnClick="cmdUpdate_Click" OnClientClick="return validate();" />
                            <asp:Button ID="cmdLamMoi2" runat="server" CssClass="buttoninput" Text="Làm mới" OnClick="cmdLamMoi_Click" />
                            <asp:Button ID="cmdQuaylai2" runat="server" CssClass="buttoninput" Text="Quay lại" OnClick="cmdQuaylai_Click" />
                        </div>
                    </div>

                 <!---------------------------->
                    <asp:Panel ID="pnKetQua" runat="server" Visible="false">
                        <div style="float: left; margin-bottom: 10px; width: 100%; position: relative; margin-top: 10px;">
                            <h4 class="tleboxchung">Kết quả giải quyết khiếu nại</h4>
                            <div class="boder" style="padding: 2%; width: 96%;">
                                <table class="table1" style="width: 95%; margin: 0 auto;">
                                <tr>
                                    <td class="col1">Kết quả GQ</td>
                                    <td colspan="3">
                                        <asp:RadioButtonList ID="rdbLoai" runat="server"
                                            Font-Bold="true" RepeatDirection="Horizontal" AutoPostBack="True">
                                            <asp:ListItem Value="0" Selected="True" Text="Chấp nhận khiếu nại"></asp:ListItem>
                                            <asp:ListItem Value="1" Text="Không chấp nhận khiếu nại"></asp:ListItem>
                                            <asp:ListItem Value="2" Text="Xếp đơn"></asp:ListItem>
                                            <asp:ListItem Value="3" Text="Giải quyết khác"></asp:ListItem>
                                        </asp:RadioButtonList>
                                    </td>
                                </tr>
                                <tr>
                                    <td> <asp:Label ID="lbl_GQD_NgayCV" runat="server"  Text="Ngày phát hành của Phòng"></asp:Label><span class="batbuoc">*</span></td>
                                    <td colspan="3">
                                        <asp:TextBox ID="txtGQD_NgayCV" runat="server" CssClass="user"
                                            onkeypress="return isNumber(event)"
                                            Width="232px" MaxLength="10"></asp:TextBox>
                                        <cc1:CalendarExtender ID="CalendarExtender9" runat="server" TargetControlID="txtGQD_NgayCV" Format="dd/MM/yyyy" Enabled="true" />
                                        <cc1:MaskedEditExtender ID="MaskedEditExtender9" runat="server" TargetControlID="txtGQD_NgayCV" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />

                                    </td>
                                </tr>
                                
                                    <tr>
                                        
                                        <td class="col1">Ngày<span class="batbuoc"></span></td>
                                        <td class="col2">
                                            <asp:TextBox ID="txtTLD_Ngay" runat="server"
                                                onkeypress="return isNumber(event)"
                                                AutoPostBack="true" 
                                                CssClass="user" Width="232px" MaxLength="10" OnTextChanged="txtTLD_Ngay_TextChanged"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender10" runat="server" TargetControlID="txtTLD_Ngay" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender10" runat="server" TargetControlID="txtTLD_Ngay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        </td>
                                        <td class="col3">Số<span class="batbuoc"></span></td>
                                        <td>
                                            <asp:TextBox ID="txtTLD_So"
                                                runat="server" CssClass="user" Width="232px" MaxLength="50"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Literal ID="lttNguoiKy" runat="server" Text="Người ký"></asp:Literal></td>
                                        <td colspan="3">
                                            <asp:TextBox ID="txtTLD_NguoiKy" runat="server" CssClass="user" Width="232px" MaxLength="240"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Ghi chú</td>
                                        <td colspan="3">
                                            <asp:TextBox ID="txtTLD_Ghichu" CssClass="user" runat="server" Width="625px"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td colspan="3">
                                            <asp:Button ID="cmdUpdateKNTP" runat="server" CssClass="buttoninput"
                                                Text="Lưu" OnClick="cmdUpdateKNTP_Click" OnClientClick="return validate_kq();" />
                                            <asp:Button ID="cmdXoa_GQKN_" runat="server" CssClass="buttoninput"
                                                Text="Xóa" OnClick="cmdXoa_GQKN_Click"
                                                OnClientClick="return confirm('Bạn muốn xóa kết quả này?');" />
                                            <asp:Button ID="cmdQuaylai4" runat="server" CssClass="buttoninput" Text="Quay lại" OnClick="cmdQuaylai_Click" />
                                        </td>

                                    </tr>

                                </table>
                                <div style="margin: 5px; width: 95%; color: red;">
                                    <asp:Label ID="lttMsgKNTP" runat="server"></asp:Label>
                                </div>
                            </div>
                        </div>
                    </asp:Panel>
                    <!---------------------------->
                   

                  </div>


                <div style="margin: 5px; width: 95%; color: red;">
                    <asp:Label ID="lttMsg" runat="server"></asp:Label>
                </div>
            </div>
        </div>
    </div>
    <script >
        function OpenLS() {
            var link = 'Popup/pPCCaBoHistory.aspx?vID=<%=hddID%>';
            PopupCenter(link, 'Lịch sử phân công', 1000, 850);
        }
    </script>
    <script>
        function validate() {
            //if (!validate_thuly())
            //    return false;
            if (!validate_banan_qd())
                return false;
            //--loai an
            var dropLoaiAn = document.getElementById('<%=dropLoaiAn.ClientID%>');
            var value_Loaian = dropLoaiAn.options[dropLoaiAn.selectedIndex].value;
            if (value_Loaian == "0") {
                alert("Bạn chưa chọn Loại án. Hãy kiểm tra lại!");
                dropLoaiAn.focus();
                return false;
            }
           
            var txtQHPL_text = document.getElementById('<%=txtQHPL_TEXT.ClientID%>');
            if (!Common_CheckTextBox(txtQHPL_text, 'Quan hệ pháp luật')) {
                txtQHPL_text.focus();
                return false;
            }
                
            var dropTTV = document.getElementById('<%=dropTTV.ClientID%>');
            var txtNgayphancong = document.getElementById('<%=txtNgayphancong.ClientID%>');
            var value_change = dropTTV.options[dropTTV.selectedIndex].value;
            if (value_change != "0" & value_change != null) {
                if (!CheckDateTimeControl(txtNgayphancong, "Ngày phân công TTV"))
                    return false;
            }
            return true;
        }
        

        function validate_thuly() {
           var txtSoThuLy = document.getElementById('<%=txtSoThuLy.ClientID%>');
            if (!Common_CheckTextBox(txtSoThuLy, 'Số thụ lý'))
                return false;
            //-----------------------------
            var txtNgayThuLy = document.getElementById('<%=txtNgayThuLy.ClientID%>');
            if (!CheckDateTimeControl(txtNgayThuLy, "Ngày thụ lý"))
                return false;

            //-----------------------------
            return true;
        }
        function validate_banan_qd() {
            var value_change = "";
            //-----------------------------ddlLoaiBA
            
            var txtSoBA = document.getElementById('<%=txtSoBA.ClientID%>');
            if (!Common_CheckTextBox(txtSoBA, 'Số BA/QĐ phúc thẩm'))
                return false;
            var txtNgayBA = document.getElementById('<%=txtNgayBA.ClientID%>');
            if (!CheckDateTimeControl(txtNgayBA, "Ngày BA/QĐ phúc thẩm"))
                return false;
            //-----------------------------
            var dropToaAn = document.getElementById('<%=dropToaAn.ClientID%>');
            value_change = dropToaAn.options[dropToaAn.selectedIndex].value;
            if (value_change == "0") {
                alert("Bạn chưa chọn Tòa án thụ lý vụ việc phúc thẩm. Hãy kiểm tra lại!");
                dropToaAn.focus();
                return false;
            }
            //-----------------------------
            return true;
        }

        function validate_ttv() {
            var txtNgayphancong = document.getElementById('<%=txtNgayphancong.ClientID%>');
            var dropTTV = document.getElementById('<%=dropTTV.ClientID%>');
            var value_change = dropTTV.options[dropTTV.selectedIndex].value;
            if (value_change != "0") {
                if (!CheckDateTimeControl(txtNgayphancong, "Ngày phân công TTV"))
                    return false;
            }

            return true;
        }

        
        function validate_kq() {
            var txtTLD_So = document.getElementById('<%=txtTLD_So.ClientID%>');
            if (!Common_CheckTextBox(txtTLD_So, 'Số trả lời đơn khiếu nại'))
                return false;
            //-----------------------------
            var txtTLD_Ngay = document.getElementById('<%=txtTLD_Ngay.ClientID%>');
            if (!CheckDateTimeControl(txtTLD_Ngay, "Ngày trả lời đơn khiếu nại"))
                return false;
            //-----------------------------

            return true;
        }

       
    </script>
    <script type="text/javascript">
        function pageLoad(sender, args) {
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }
        }
    </script>
</asp:Content>
