<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="NguoiThamgiaTT.aspx.cs" Inherits="WEB.GSTP.QLAN.AKT.Hoso.NguoiThamgiaTT" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style type="text/css">
        .ADS_ToTung_Col1 {
            width: 152px;
        }

        .ADS_ToTung_Col2 {
            width: 324px;
        }

        .ADS_ToTung_Col3 {
            width: 80px;
        }

        .lblTitleTT {
            margin: 6px 5px 0px 10px;
            width: 55px;
            float: left;
        }

        .floatF {
            float: left;
        }

        .Text_AlignR {
            text-align: right;
        }

        .namsinh {
            float: left;
            margin: 6px 5px 0px 10px;
            width: 84px;
        }

        .clcheckbox {
            margin-left: 10px;
            display: inline-block;
            margin-top: 5px;
        }
    </style>
    <asp:HiddenField ID="lstDataDuongSu" Value="" runat="server" />
    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
    <asp:HiddenField ID="hddNgayNhanDon" Value="" runat="server" />
    <asp:HiddenField ID="hddShowCommand" runat="server" Value="True" />
    <div class="box">
        <div class="box_nd">
            <div class="boxchung">
                <h4 class="tleboxchung">Thông tin người tham gia tố tụng</h4>
                <div class="boder" style="padding: 10px;">
                    <table class="table1">
                        <tr>
                            <td>Tư cách tham gia tố tụng<span class="batbuoc">(*)</span></td>
                            <td colspan="1">
                                <asp:DropDownList AutoPostBack="true" ID="ddlTucachTGTT" CssClass="chosen-select" runat="server" Width="318px">
                                </asp:DropDownList>
                            </td>
                            <%--<td>Số CMND/ Thẻ căn cước/ Hộ chiếu<span id="ltCMNDBD"></span></td>
                                <td style="width:308px">
                                    <asp:TextBox ID="txtBD_CMND" CssClass="user" runat="server" Width="308px" MaxLength="250"></asp:TextBox></td>--%>
                            <td>Số CMND <span id="ltCMNDBD"></span></td>
                            <td style="width: 308px">
                                <asp:TextBox ID="txtBD_CMND" CssClass="user" runat="server" Width="308px" MaxLength="250"></asp:TextBox></td>
                            <td>
                                <asp:CheckBox ID="chkBoxCMNDBD" runat="server" Text="Không có" />
                            </td>
                        </tr>
                        <tr>
                            <td>Thẻ căn cước <span class="batbuoc">(*)</span><span id="ltCCCDBD"></span></td>
                            <td style="width: 308px">
                                <asp:TextBox ID="txtBD_CCCD" CssClass="user" runat="server" Width="308px" MaxLength="250"></asp:TextBox></td>
                            <td>Hộ chiếu <span id="ltHCBD"></span></td>
                            <td style="width: 308px">
                                <asp:TextBox ID="txtBD_HoChieu" CssClass="user" runat="server" Width="308px" MaxLength="250"></asp:TextBox></td>
                        </tr>
                        <tr>
                            <td class="ADS_ToTung_Col1">Họ tên người TGTT<span class="batbuoc">(*)</span></td>
                            <td class="ADS_ToTung_Col2">
                                <asp:TextBox ID="txtHoten" CssClass="user" runat="server" Width="310px"></asp:TextBox>
                            </td>
                            <td class="ADS_ToTung_Col3">Ngày tham gia</td>
                            <td>
                                <asp:TextBox ID="txtNgaythamgia" runat="server" CssClass="user" Width="80px" MaxLength="10"></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtNgaythamgia" Format="dd/MM/yyyy" Enabled="true" />
                                <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtNgaythamgia" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                            </td>
                        </tr>
                        <tr>
                            <td>Nơi tạm trú</td>
                            <td>
                                <asp:TextBox ID="txtND_TTChitiet" CssClass="user" runat="server" Width="310px" MaxLength="250"></asp:TextBox></td>
                            <td>Nơi ĐKHKTT</td>
                            <td>
                                <asp:TextBox ID="txtND_HKTT_Chitiet" CssClass="user" runat="server" Width="310px" MaxLength="250"></asp:TextBox></td>
                        </tr>
                        <tr>
                            <td>Giới tính</td>
                            <td>
                                <div class="floatF">
                                    <asp:DropDownList ID="ddlND_Gioitinh" CssClass="chosen-select" runat="server" Width="124px">
                                         <asp:ListItem Value="0" Text="Chọn" Selected="True"></asp:ListItem>
                                            <asp:ListItem Value="1" Text="Nam"></asp:ListItem>
                                            <asp:ListItem Value="2" Text="Nữ"></asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                                <span class="lblTitleTT">Ngày sinh</span>
                                <asp:TextBox ID="txtND_Ngaysinh" runat="server" CssClass="user floatF" Width="116px" MaxLength="10" AutoPostBack="True" OnTextChanged="txtND_Ngaysinh_TextChanged"></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtND_Ngaysinh" Format="dd/MM/yyyy" Enabled="true" />
                                <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server" TargetControlID="txtND_Ngaysinh" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                            </td>
                            <td>Năm sinh</td>
                            <td>
                                <asp:TextBox ID="txtND_Namsinh" CssClass="user floatF Text_AlignR" onkeypress="return isNumber(event)" runat="server" Width="80px" MaxLength="4"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td>Điện thoại</td>
                            <td>
                                <asp:TextBox ID="txtDienThoai" CssClass="user floatF Text_AlignR" onkeypress="return isNumber(event)" runat="server" Width="116px"></asp:TextBox>
                                <span class="lblTitleTT">Fax</span>
                                <asp:TextBox ID="txtFax" CssClass="user floatF Text_AlignR" onkeypress="return isNumber(event)" runat="server" Width="116px"></asp:TextBox>
                                <span class="namsinh"></span>
                            </td>
                            <td>Email</td>
                            <td>
                                <asp:TextBox ID="txtEmail" CssClass="user floatF" runat="server" Width="310px"></asp:TextBox>
                            </td>
                        </tr>

                        <%--------------------------------------------------------------------%>
                        <asp:Panel ID="pn_daidien" runat="server" Visible="false">
                            <tr>
                                <td>Tên văn phòng luật sư</td>
                                <td>
                                    <asp:TextBox ID="txt_TEN_VPLS" CssClass="user"
                                        runat="server" MaxLength="250" Width="310"></asp:TextBox></td>
                                <td>Đoàn luật sư</td>
                                <td>
                                    <asp:TextBox ID="txt_DOAN_LS" CssClass="user"
                                        runat="server" MaxLength="250" Width="310"></asp:TextBox></td>
                            </tr>
                            <tr>
                                <td>Sổ đăng ký số <span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:TextBox ID="txt_SO_DK" CssClass="user"
                                        runat="server" MaxLength="250" Width="310"></asp:TextBox></td>
                                <td>Ngày đăng ký<span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:TextBox ID="txt_NGAY_DK" runat="server" CssClass="user" Width="310px" MaxLength="10"></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender3" runat="server" TargetControlID="txt_NGAY_DK" Format="dd/MM/yyyy" Enabled="true" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txt_NGAY_DK" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                    <cc1:MaskedEditValidator ID="MaskedEditValidator1" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txt_NGAY_DK" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                </td>
                            </tr>

                            <tr>
                                <td>Địa chỉ</td>
                                <td>
                                    <asp:TextBox ID="txt_DIA_CHI" CssClass="user"
                                        runat="server" MaxLength="250" Width="310"></asp:TextBox></td>
                                <td>Người ký giấy XN</td>
                                <td>
                                    <asp:DropDownList ID="ddlNguoiphancong" CssClass="chosen-select" runat="server" Width="318px"></asp:DropDownList>
                                <td colspan="2"></td>
                            </tr>
                        </asp:Panel>

                    </table>
                    <asp:Panel ID="pnItemDs" runat="server">
                        <table class="table1">
                            <tr>
                                <td style="width: 157px">Đại diện cho</td>
                                <td style="border: 1px solid #b9b7b7; padding: 5px 0px 12px 0px; width: 734px; background-color: #f5f4f4;">

                                    <asp:Panel runat="server" ID="pnDuongSuDON_GHEP">
                                    </asp:Panel>

                                </td>

                                <td colspan="3"></td>
                            </tr>
                        </table>
                    </asp:Panel>
                </div>
            </div>


            <%--------------------------------------------------------------------%>
            <div class="boxchung">
                <h4 class="tleboxchung">In giấy xác nhận
                 <asp:LinkButton ID="lbtTTBC" runat="server" Text="[ Mở ]" ForeColor="#0E7EEE" OnClick="lbtTTBC_Click"></asp:LinkButton></h4>
                <div class="boder" style="padding: 10px;">
                    <asp:Panel ID="pnTTBC" runat="server" Visible="true">
                        <table class="table1">
                            <tr>
                                <td colspan="7">
                                    <div style="float: left">
                                        <asp:Label runat="server" ID="lbthongbao_export" ForeColor="Red"></asp:Label>
                                    </div>
                                    <div style="margin-top: 10px; float: right;" id="divPrintNoibo" runat="server">
                                        <asp:Button ID="btn_GXN_NBC" runat="server" Width="225px" padding-left="0px" CssClass="buttonprint" OnClick="btn_GXN_NBC_Click" Text="Giấy XN người bào chữa" />

                                    </div>
                                </td>
                            </tr>
                        </table>
                    </asp:Panel>
                </div>
            </div>
            <div class="truong">
                <table class="table1">
                    <tr>
                        <td colspan="2" style="text-align: center;">
                            <asp:Button ID="cmdUpdate" runat="server" CssClass="buttoninput" OnClientClick="return ValidDataInput();" Text="Lưu" OnClick="btnUpdate_Click" />
                            <asp:Button ID="cmdLammoi" runat="server" CssClass="buttoninput" Text="Làm mới" OnClick="btnLammoi_Click" />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <div>
                                <asp:HiddenField ID="hddid" runat="server" Value="0" />
                                <asp:Label runat="server" ID="lbthongbao" ForeColor="Red"></asp:Label>
                            </div>
                            <asp:Panel runat="server" ID="pndata" Visible="false">
                                <div class="phantrang">
                                    <div class="sobanghi">
                                        <asp:Literal ID="lstSobanghiT" runat="server"></asp:Literal>
                                    </div>
                                    <div class="sotrang">
                                        <asp:LinkButton ID="lbTBack" runat="server" CausesValidation="false" CssClass="back"
                                            OnClick="lbTBack_Click"></asp:LinkButton>
                                        <asp:LinkButton ID="lbTFirst" runat="server" CausesValidation="false" CssClass="active"
                                            Text="1" OnClick="lbTFirst_Click"></asp:LinkButton>
                                        <asp:Label ID="lbTStep1" runat="server" Text="..."></asp:Label>
                                        <asp:LinkButton ID="lbTStep2" runat="server" CausesValidation="false" CssClass="so"
                                            Text="2" OnClick="lbTStep_Click"></asp:LinkButton>
                                        <asp:LinkButton ID="lbTStep3" runat="server" CausesValidation="false" CssClass="so"
                                            Text="3" OnClick="lbTStep_Click"></asp:LinkButton>
                                        <asp:LinkButton ID="lbTStep4" runat="server" CausesValidation="false" CssClass="so"
                                            Text="4" OnClick="lbTStep_Click"></asp:LinkButton>
                                        <asp:LinkButton ID="lbTStep5" runat="server" CausesValidation="false" CssClass="so"
                                            Text="5" OnClick="lbTStep_Click"></asp:LinkButton>
                                        <asp:Label ID="lbTStep6" runat="server" Text="..."></asp:Label>
                                        <asp:LinkButton ID="lbTLast" runat="server" CausesValidation="false" CssClass="so"
                                            Text="100" OnClick="lbTLast_Click"></asp:LinkButton>
                                        <asp:LinkButton ID="lbTNext" runat="server" CausesValidation="false" CssClass="next"
                                            OnClick="lbTNext_Click"></asp:LinkButton>
                                    </div>
                                </div>
                                <asp:DataGrid ID="dgList" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                    PageSize="20" AllowPaging="True" GridLines="None" PagerStyle-Mode="NumericPages"
                                    CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                    ItemStyle-CssClass="chan" Width="100%"
                                    OnItemCommand="dgList_ItemCommand" OnItemDataBound="dgList_ItemDataBound">
                                    <Columns>
                                        <asp:BoundColumn DataField="Ma" Visible="false"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="ID" Visible="false"></asp:BoundColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="20px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                <asp:CheckBox ID="chkChonAll" AutoPostBack="true" OnCheckedChanged="chkChonAll_CheckChange" ToolTip="Chọn tất cả" runat="server" />
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:CheckBox ID="chkChon" ToolTip='<%#Eval("ID")%>' runat="server" />
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="20px" ItemStyle-Width="20px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>TT</HeaderTemplate>
                                            <ItemTemplate><%# Container.DataSetIndex + 1 %></ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:BoundColumn DataField="HOTEN" HeaderText="Họ và tên" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="TENTC" HeaderText="Tư cách TGTT" HeaderStyle-Width="90px" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="Tamtru" HeaderText="Địa chỉ tạm trú" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="TENDUONGSU" HeaderText="Tên đương sự" HeaderStyle-Width="150px" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="chucvuchucdanh" HeaderText="Người ký - Chức vụ" HeaderStyle-Width="150px" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="NGAYTHAMGIA" HeaderText="Ngày tham gia" HeaderStyle-Width="65px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="NGUOITAO" HeaderText="Người tạo" HeaderStyle-Width="65px" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="NGAYTAO" HeaderText="Ngày tạo" HeaderStyle-Width="65px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy HH:mm}"></asp:BoundColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="60px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Thao tác
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:LinkButton ID="lblSua" runat="server" Text="Sửa" CausesValidation="false" CommandName="Sua" ForeColor="#0e7eee"
                                                    CommandArgument='<%#Eval("ID") %>'></asp:LinkButton>
                                                &nbsp;&nbsp;<asp:LinkButton ID="lbtXoa" runat="server" CausesValidation="false" Text="Xóa" ForeColor="#0e7eee"
                                                    CommandName="Xoa" CommandArgument='<%#Eval("ID") %>' ToolTip="Xóa" OnClientClick="return confirm('Bạn thực sự muốn xóa bản ghi này? ');"></asp:LinkButton>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:BoundColumn DataField="TOA_GIAIQUYET_ID" Visible="false"></asp:BoundColumn>
                                    </Columns>
                                    <HeaderStyle CssClass="header"></HeaderStyle>
                                    <ItemStyle CssClass="chan"></ItemStyle>
                                    <PagerStyle Visible="false"></PagerStyle>
                                </asp:DataGrid>
                                <div class="phantrang">
                                    <div class="sobanghi">
                                        <asp:Literal ID="lstSobanghiB" runat="server"></asp:Literal>
                                    </div>
                                    <div class="sotrang">
                                        <asp:LinkButton ID="lbBBack" runat="server" CausesValidation="false" CssClass="back"
                                            OnClick="lbTBack_Click"></asp:LinkButton>
                                        <asp:LinkButton ID="lbBFirst" runat="server" CausesValidation="false" CssClass="active"
                                            Text="1" OnClick="lbTFirst_Click"></asp:LinkButton>
                                        <asp:Label ID="lbBStep1" runat="server" Text="..."></asp:Label>
                                        <asp:LinkButton ID="lbBStep2" runat="server" CausesValidation="false" CssClass="so"
                                            Text="2" OnClick="lbTStep_Click"></asp:LinkButton>
                                        <asp:LinkButton ID="lbBStep3" runat="server" CausesValidation="false" CssClass="so"
                                            Text="3" OnClick="lbTStep_Click"></asp:LinkButton>
                                        <asp:LinkButton ID="lbBStep4" runat="server" CausesValidation="false" CssClass="so"
                                            Text="4" OnClick="lbTStep_Click"></asp:LinkButton>
                                        <asp:LinkButton ID="lbBStep5" runat="server" CausesValidation="false" CssClass="so"
                                            Text="5" OnClick="lbTStep_Click"></asp:LinkButton>
                                        <asp:Label ID="lbBStep6" runat="server" Text="..."></asp:Label>
                                        <asp:LinkButton ID="lbBLast" runat="server" CausesValidation="false" CssClass="so"
                                            Text="100" OnClick="lbTLast_Click"></asp:LinkButton>
                                        <asp:LinkButton ID="lbBNext" runat="server" CausesValidation="false" CssClass="next"
                                            OnClick="lbTNext_Click"></asp:LinkButton>
                                    </div>
                                </div>
                            </asp:Panel>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        $(document).ready(function () {
            loadeventchange();
            //setValidateCMND();
        })

        function setValidateCMND() {
            var ltCMNDBD = document.getElementById('ltCMNDBD');
            ltCMNDBD.innerHTML = "<span style='color:red'>(*)</span>";
            $('#pnRight').off('change');
            $('#pnRight').on('change', '#<%=chkBoxCMNDBD.ClientID%>', function () {
                var ltCMNDBD = document.getElementById('ltCMNDBD');
                if ($(this).is(':checked')) {
                    ltCMNDBD.innerHTML = "";
                }
                else {
                    ltCMNDBD.innerHTML = "<span style='color:red'>(*)</span>";
                }
            })
        }

        function loadeventchange() {
            if ($('#<%=chkBoxCMNDBD.ClientID%>').is(':checked')) {
                ltCMNDBD.innerHTML = "";
            }
            else {
                ltCMNDBD.innerHTML = "<span style='color:red'>(*)</span>";
            }
            $('#dvSpliter_ContentPlaceHolder1_pnDuongSuDON_GHEP').off('change');
            $("#dvSpliter_ContentPlaceHolder1_pnDuongSuDON_GHEP").on('change', '.clcheckbox input:first-child', function (e) {
                let data = $('#dvSpliter_ContentPlaceHolder1_lstDataDuongSu').val();



                if (data == '') {
                    data = ',';
                }
                else {
                    if (data[0] != ',') {
                        data = ',' + data;
                    }
                    if (data[data.length - 1] != ',') {
                        data = data + ',';
                    }
                }
                let tcttcheck = $(this).attr('tctt');
                let idcheck = $(this).parent(".clcheckbox").attr('title');
                $('.clcheckbox input:first-child').each(function () {
                    let idcurrent = $(this).parent(".clcheckbox").attr('title');
                    let tcttcurent = $(this).attr('tctt');
                    if (this.checked && idcheck != idcurrent) {
                        if (tcttcheck != tcttcurent) {
                            ischeck = false;
                            data = data.replace("," + $(this).parent(".clcheckbox").attr('title') + ",", ",");
                            $(this).prop('checked', false);
                        }
                    }
                })
                if (this.checked) {
                    //thêm
                    data += $(this).parent(".clcheckbox").attr('title') + ",";
                }
                else {
                    data = data.replace("," + $(this).parent(".clcheckbox").attr('title') + ",", ",");
                }

                if (data == '') {
                    data = ',';
                }
                else {
                    if (data[0] != ',') {
                        data = ',' + data;
                    }
                    if (data[data.length - 1] != ',') {
                        data = data + ',';
                    }
                }
                console.log(data);
                $('#dvSpliter_ContentPlaceHolder1_lstDataDuongSu').val(data);
            })



        }



        function ValidDataInput() {
            var ddlTucachTGTT = document.getElementById('<%=ddlTucachTGTT.ClientID%>');
            var val = ddlTucachTGTT.options[ddlTucachTGTT.selectedIndex].value;
            if (val == 0) {
                alert('Bạn chưa chọn tư cách tham gia tố tụng. Hãy chọn lại!');
                ddlTucachTGTT.focus();
                return false;
            }
           <%-- if (!$('#<%=chkBoxCMNDBD.ClientID%>').is(':checked')) {
                var txtBD_CMND = document.getElementById('<%=txtBD_CMND.ClientID%>');
                if (txtBD_CMND.value.trim().length == 0) {
                    alert('Bạn chưa nhập Số CMND/ Thẻ căn cước/ Hộ chiếu. Hãy chọn lại!');
                    txtBD_CMND.focus();
                    return false;
                }
            }--%>
            var txtHoten = document.getElementById('<%=txtHoten.ClientID%>');
            var lengthHoten = txtHoten.value.trim().length;
            if (lengthHoten == 0) {
                alert('Bạn chưa nhập họ tên người tham gia tố tụng!');
                txtHoten.focus();
                return false;
            }
            if (lengthHoten > 250) {
                alert('Họ tên người tham gia tố tụng không nhập quá 250 ký tự. Hãy nhập lại!');
                txtHoten.focus();
                return false;
            }
            var DateNow = Date.now();
            var txtNgaythamgia = document.getElementById('<%=txtNgaythamgia.ClientID%>');
            if (txtNgaythamgia.value.trim().length > 0) {
                var arr = txtNgaythamgia.value.split('/');
                var D = new Date(arr[2] + '-' + arr[1] + '-' + arr[0]);
                if (D.toString() == "NaN" || D.toString() == "Invalid Date") {
                    alert('Bạn phải nhập ngày tham gia theo định dạng (dd/MM/yyyy).');
                    txtNgaythamgia.focus();
                    return false;
                }
                var hddNgayNhanDon = document.getElementById('<%=hddNgayNhanDon.ClientID%>');
                var NgayNhanDon;
                if (hddNgayNhanDon.value != "") {
                    var arr = hddNgayNhanDon.value.split('/');
                    NgayNhanDon = new Date(arr[2] + '-' + arr[1] + '-' + arr[0]);
                }
                if (D < NgayNhanDon) {
                    alert('Bạn phải nhập ngày tham gia lớn hơn ngày nhận đơn ' + hddNgayNhanDon.value + '!');
                    txtNgaythamgia.focus();
                    return false;
                }
                if (D > DateNow) {
                    alert('Bạn phải nhập ngày tham gia nhỏ hơn ngày hiện tại!');
                    txtNgaythamgia.focus();
                    return false;
                }
            }
            var txtND_TTChitiet = document.getElementById('<%=txtND_TTChitiet.ClientID%>');
            if (txtND_TTChitiet.value.trim().length > 250) {
                alert('Nơi tạm trú chi tiết không nhập quá 250 ký tự. Hãy nhập lại!');
                txtND_TTChitiet.focus();
                return false;
            }
            var txtND_HKTT_Chitiet = document.getElementById('<%=txtND_HKTT_Chitiet.ClientID%>');
            if (txtND_HKTT_Chitiet.value.trim().length > 250) {
                alert('Nơi ĐKHKTT chi tiết không nhập quá 250 ký tự. Hãy nhập lại!');
                txtND_HKTT_Chitiet.focus();
                return false;
            }
            var txtND_Ngaysinh = document.getElementById('<%=txtND_Ngaysinh.ClientID%>');
            if (txtND_Ngaysinh.value.trim().length > 0) {
                var arr = txtND_Ngaysinh.value.split('/');
                var D = new Date(arr[2] + '-' + arr[1] + '-' + arr[0]);
                if (D.toString() == "NaN" || D.toString() == "Invalid Date") {
                    alert('Bạn phải nhập ngày sinh theo định dạng (dd/MM/yyyy).');
                    txtND_Ngaysinh.focus();
                    return false;
                }
                if (D > DateNow) {
                    alert('Bạn phải nhập ngày sinh nhỏ hơn ngày hiện tại!');
                    txtND_Ngaysinh.focus();
                    return false;
                }
            }
           
            var txtDienThoai = document.getElementById('<%=txtDienThoai.ClientID%>');
            if (txtDienThoai.value.trim().length > 250) {
                alert('Điện thoại không nhập quá 250 ký tự. Hãy nhập lại!');
                txtDienThoai.focus();
                return false;
            }
            var txtFax = document.getElementById('<%=txtFax.ClientID%>');
            if (txtFax.value.trim().length > 250) {
                alert('Fax không nhập quá 250 ký tự. Hãy nhập lại!');
                txtFax.focus();
                return false;
            }
            var txtEmail = document.getElementById('<%=txtEmail.ClientID%>');
            var lengthEmail = txtEmail.value.trim().length;
            if (lengthEmail > 0) {
                var email = txtEmail.value;
                var atpos = email.indexOf("@");
                var dotpos = email.lastIndexOf(".");
                if (atpos < 1 || dotpos < atpos + 2 || dotpos + 2 >= txtEmail.value.length) {
                    alert("Địa chỉ email chưa đúng.");
                    txtEmail.focus();
                    return false;
                }
                if (lengthEmail > 250) {
                    alert('Email không nhập quá 250 ký tự. Hãy nhập lại!');
                    txtEmail.focus();
                    return false;
                }
            }
            <%--var txtNDD_Hoten = document.getElementById('<%=txtNDD_Hoten.ClientID%>');
            if (txtNDD_Hoten.value.trim().length > 250) {
                alert('Đại diện cho không nhập quá 250 ký tự. Hãy nhập lại!');
                txtNDD_Hoten.focus();
                return false;
            }--%>
            return true;
        }
        function pageLoad(sender, args) {
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }
        }
        function isNumber(evt) {
            evt = (evt) ? evt : window.event;
            var charCode = (evt.which) ? evt.which : evt.keyCode;
            if (charCode > 31 && (charCode < 48 || charCode > 57)) {
                return false;
            }
            return true;
        }
    </script>
</asp:Content>
