using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using AutoMapper;
using DominioUser;

namespace ServiceUser.Profiles
{
    public class UserProfile: Profile
    {
        public UserProfile()
        {
            CreateMap<User, UserReadDTO>()
            .ForMember(dest => dest.Cpf, opt => opt.MapFrom(src => MaskCpf(src.Cpf)))
            .ForMember(dest => dest.Endereco, opt => opt.MapFrom(src => src.Endereco))
            .ForMember(dest => dest.NumerosDeApoio, opt => opt.MapFrom(src => src.NumerosDeApoio));

            CreateMap<Endereco, EnderecoDto>()
                .ForMember(dest => dest.Id, opt => opt.MapFrom(src => src.UserId)); // CORREÇÃO IMPORTANTE

            CreateMap<Apoios, ApoiosDto>();


            // ----------- DTO → ENTIDADE (CRIAÇÃO / ATUALIZAÇÃO) -----------
            CreateMap<EnderecoDto, Endereco>()
                .ForMember(dest => dest.UserId, opt => opt.Ignore()); // sempre setado no service
                                                                      // NÃO MAPEAR dest.Id — NO SEU MODEL NÃO EXISTE Id, EXISTE UserId

            CreateMap<ApoiosDto, Apoios>()
                .ForMember(dest => dest.UserId, opt => opt.Ignore()); // idem

            CreateMap<UserCreateDto, User>()
                .ForMember(dest => dest.PasswordHash, opt => opt.Ignore()) // hash no service
                .ForMember(dest => dest.Endereco, opt => opt.MapFrom(src => src.Endereco))
                .ForMember(dest => dest.NumerosDeApoio, opt => opt.MapFrom(src => src.Apoios));

            CreateMap<UserUpdateDto, User>()
                .ForMember(dest => dest.PasswordHash, opt => opt.Ignore())
                .ForMember(dest => dest.Endereco, opt => opt.MapFrom(src => src.Endereco))
                .ForMember(dest => dest.NumerosDeApoio, opt => opt.MapFrom(src => src.Apoios));
        }

        private static string MaskCpf(string cpf)
        {
            if (string.IsNullOrEmpty(cpf) || cpf.Length < 11)
                return cpf;
            // ex: 12345678901 -> ***.***.890-1 (exemplo simples)
            return $"***.***.{cpf.Substring(6, 3)}-{cpf.Substring(9)}";
        }
    }
}
